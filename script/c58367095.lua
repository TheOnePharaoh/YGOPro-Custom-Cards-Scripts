--Evasion
function c58367095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c58367095.condition)
	e1:SetTarget(c58367095.target)
	e1:SetOperation(c58367095.activate)
	c:RegisterEffect(e1)
end
function c58367095.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c58367095.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and c58367095.cfilter(tg:GetFirst()) and Duel.IsChainNegatable(ev)
end
function c58367095.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c58367095.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end