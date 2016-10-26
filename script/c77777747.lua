--Revival of the Necromantic Shade
function c77777747.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77777747.condition)
	e1:SetTarget(c77777747.target)
	e1:SetOperation(c77777747.activate)
	c:RegisterEffect(e1)
end
function c77777747.filter2(c)
	return c:IsSetCard(0x1c8) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c77777747.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77777747.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c77777747.filter(c)
	return c:IsAbleToDeck()
end
function c77777747.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777747.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c77777747.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function c77777747.thfilter(c)
	return c:IsSetCard(0x1c8) and c:GetType()==0x82 and c:IsAbleToHand()
end

function c77777747.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c77777747.filter,tp,LOCATION_REMOVED,0,nil)
	local count=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	Duel.SendtoDeck(g,nil,count,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	if Duel.Recover(tp,count*300,REASON_EFFECT)>0 and Duel.IsExistingTarget(c77777747.thfilter,tp,LOCATION_GRAVE,0,1,nil)then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g2=Duel.SelectTarget(tp,c77777747.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
