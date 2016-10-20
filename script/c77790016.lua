--Symbol Fragment: Truth
function c77790016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77790016.target)
	e1:SetOperation(c77790016.activate)
	c:RegisterEffect(e1)
end
function c77790016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,1-tp,LOCATION_HAND)
end
function c77790016.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
 	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,tp,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g1:GetCount()==0 then return end
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local ag1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(ag1,tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
