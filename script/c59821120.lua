--Virgo's Light
function c59821120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,59821120)
	e1:SetCondition(c59821120.condition)
	e1:SetTarget(c59821120.target)
	e1:SetOperation(c59821120.activate)
	c:RegisterEffect(e1)
end
function c59821120.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ) and c:IsRankAbove(5)
end
function c59821120.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c59821120.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c59821120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c59821120.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c59821120.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c59821120.thfilter,tp,LOCATION_GRAVE,0,nil,code)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821120,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end