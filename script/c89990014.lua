--Mystical Aura of Renovation
function c89990014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c89990014.target)
	e1:SetOperation(c89990014.activate)
	c:RegisterEffect(e1)
end
function c89990014.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x22b) and c:IsAbleToDeck()
end
function c89990014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89990014.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingTarget(c89990014.filter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c89990014.filter,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function c89990014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	end
end
