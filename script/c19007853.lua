--Mechquipped's Counter Laser
function c19007853.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c19007853.condition)
	e1:SetTarget(c19007853.target)
	e1:SetOperation(c19007853.activate)
	c:RegisterEffect(e1)
end
function c19007853.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007853.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c19007853.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c19007853.disfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158) and c:IsAbleToDeck()
end
function c19007853.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19007853.disfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c19007853.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c19007853.disfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
