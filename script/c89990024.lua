--Shine of Opposite Auroras
function c89990024.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c89990024.cost)
	e1:SetTarget(c89990024.target)
	e1:SetOperation(c89990024.operation)
	c:RegisterEffect(e1)
end
function c89990024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c89990024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
 	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c89990024.operation(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc and hc:IsRelateToEffect(e) and Duel.SendtoDeck(hc,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end	
end
