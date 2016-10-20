--Straying Rhapsody - Song of Uncontrolable Emotions
function c19820002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19820002.target)
	e1:SetOperation(c19820002.activate)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19820002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c19820002.thcon)
	e2:SetTarget(c19820002.thtg)
	e2:SetOperation(c19820002.thop)
	c:RegisterEffect(e2)
	--shuffle and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19820002,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c19820002.shucon)
	e3:SetCost(c19820002.shucost)
	e3:SetTarget(c19820002.shutg)
	e3:SetOperation(c19820002.shuop)
	c:RegisterEffect(e3)
end
function c19820002.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c19820002.filter2(c)
	return c:IsSetCard(0x0dac406) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(19820002) and c:IsAbleToDeck()
end
function c19820002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c19820002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19820002.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c19820002.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c19820002.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local g2=Duel.SelectTarget(tp,c19820002.filter2,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c19820002.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function c19820002.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c19820002.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406)
end
function c19820002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19820002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19820002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19820002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c19820002.cshufilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404)
end
function c19820002.shucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19820002.cshufilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19820002.shufilter(c)
	return c:IsSetCard(0x0dac406) and c:IsAbleToDeck()
end
function c19820002.shucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19820002.shufilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c19820002.shufilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c19820002.shutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19820002.shuop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
