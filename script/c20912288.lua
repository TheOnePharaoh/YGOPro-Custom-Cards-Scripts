--Elisa
function c20912288.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912288,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20912288.descon)
	e1:SetTarget(c20912288.destg)
	e1:SetOperation(c20912288.desop)
	c:RegisterEffect(e1)
	--destroy2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(20912288,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e2:SetCondition(c20912288.condition)
	e2:SetCost(c20912288.cost)
	e2:SetTarget(c20912288.target)
	e2:SetOperation(c20912288.operation)
	c:RegisterEffect(e2)
end
function c20912288.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c20912288.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
	end
end
function c20912288.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end
function c20912288.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0xd0a2)
end
function c20912288.costfilter(c)
	return c:IsSetCard(0xd0a2) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c20912288.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
		and e:GetHandler():GetEquipGroup():IsExists(c20912288.costfilter,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	local g=e:GetHandler():GetEquipGroup():Filter(c20912288.costfilter,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c20912288.desfilter(c)
	return c:IsDestructable()
end
function c20912288.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c20912288.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)
end
function c20912288.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912288.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
