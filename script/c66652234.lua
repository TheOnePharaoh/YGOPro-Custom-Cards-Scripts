--Darkness Confession
function c66652234.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c66652234.condition)
	e1:SetTarget(c66652234.target)
	e1:SetOperation(c66652234.activate)
	c:RegisterEffect(e1)
end
function c66652234.cfilter(c)
	return c:IsFaceup() and c:IsCode(66652245) or c:IsCode(66652246)
end
function c66652234.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66652234.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66652234.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c66652234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c66652234.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c66652234.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c66652234.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c66652234.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end
