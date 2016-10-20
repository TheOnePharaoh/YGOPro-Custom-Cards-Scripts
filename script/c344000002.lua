--Garbage Champion
function c344000002.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(344000002,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c344000002.target)
	e1:SetOperation(c344000002.operation)
	c:RegisterEffect(e1)
	--negate atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(344000002,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCost(c344000002.cost)
	e2:SetOperation(c344000002.op)
	c:RegisterEffect(e2)
end
function c344000002.filter(c)
	return c:IsCode(18698739) and c:IsAbleToDeck()
end
function c344000002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c344000002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c344000002.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c344000002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c344000002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c344000002.cfilter(c)
	return c:IsCode(18698739) and c:IsDiscardable()
end
function c344000002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c344000002.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c344000002.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c344000002.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

