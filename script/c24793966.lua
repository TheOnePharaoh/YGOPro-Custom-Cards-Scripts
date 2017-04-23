--Vocaloid Alternation Duke Venomania
function c24793966.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c24793966.val)
	c:RegisterEffect(e1)
	--set card destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24793966,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e2:SetCost(c24793966.cost)
	e2:SetTarget(c24793966.target)
	e2:SetOperation(c24793966.operation)
	c:RegisterEffect(e2)
end
function c24793966.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c24793966.val(e,c)
	return Duel.GetMatchingGroupCount(c24793966.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c)*600
end
function c24793966.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c24793966.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c24793966.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24793966.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c24793966.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c24793966.climit)
end
function c24793966.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24793966.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c24793966.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
