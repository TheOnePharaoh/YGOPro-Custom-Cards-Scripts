--G.R.M. Sword
function c55438815.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c55438815.condition)
	e1:SetCost(c55438815.cost)
	e1:SetTarget(c55438815.target)
	e1:SetOperation(c55438815.activate)
	c:RegisterEffect(e1)
end
function c55438815.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd70)
end
function c55438815.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c55438815.filter,tp,LOCATION_MZONE,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c55438815.cfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438815.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438815.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55438815.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438815.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c55438815.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end