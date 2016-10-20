--The Idol's Gift
function c59821122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821122)
	e1:SetTarget(c59821122.target)
	e1:SetOperation(c59821122.activate)
	c:RegisterEffect(e1)
end
function c59821122.tgfilter(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
	end
end
function c59821122.desfilter(c)
	return c59821122.tgfilter(c) and c:IsDestructable()
end
function c59821122.filter(c)
	return c:IsSetCard(0xa1a2) and c:IsAbleToDeck()
end
function c59821122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c59821122.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821122.desfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c59821122.desfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821122.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c59821122.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c59821122.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c59821122.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c59821122.filter,tp,LOCATION_GRAVE,0,nil)
	local count=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	Duel.SendtoDeck(g,nil,count,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	if Duel.Recover(tp,count*300,REASON_EFFECT)>0 and Duel.IsExistingTarget(c59821122.thfilter,tp,LOCATION_DECK,0,1,nil)then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g2=Duel.SelectTarget(tp,c59821122.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
end