--Overlay Block
function c91724535.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c91724535.condition)
	e1:SetCost(c91724535.cost)
	e1:SetTarget(c91724535.target)
	e1:SetOperation(c91724535.activate)
	c:RegisterEffect(e1)
end
function c91724535.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ)
end
function c91724535.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c91724535.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c91724535.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c91724535.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c91724535.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
