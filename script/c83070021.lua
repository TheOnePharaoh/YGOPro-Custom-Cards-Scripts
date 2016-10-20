--Hydrush Restoration
function c83070021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c83070021.cost)
	e1:SetTarget(c83070021.target)
	e1:SetOperation(c83070021.activate)
	c:RegisterEffect(e1)
end
function c83070021.cfilter(c)
	return c:GetCounter(0x1837)>0
end
function c83070021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83070021.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c83070021.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local t=g:GetFirst()
	while t do
		t:RemoveCounter(tp,0x1837,t:GetCounter(0x1837),REASON_COST)
		t=g:GetNext()
	end
end
function c83070021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c83070021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
