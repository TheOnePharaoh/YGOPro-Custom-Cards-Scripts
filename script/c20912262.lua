--Sword Art Advanced Style - Symbol of Perfection
function c20912262.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c20912262.condition)
	e1:SetTarget(c20912262.target)
	e1:SetOperation(c20912262.activate)
	c:RegisterEffect(e1)
end
function c20912262.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0xd0a2)
end
function c20912262.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c20912262.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c20912262.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c20912262.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end
