--Sierra, Guardian of the Creator
function c11478404.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11478404,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,11478404)
	e1:SetTarget(c11478404.rectg)
	e1:SetOperation(c11478404.recop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478404,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c11478404.tdcon)
	e3:SetTarget(c11478404.tdtg)
	e3:SetOperation(c11478404.tdop)
	c:RegisterEffect(e3)
end
function c11478404.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c11478404.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local gc=Duel.GetMatchingGroupCount(Card.IsSetCard,p,LOCATION_GRAVE,0,nil,0xf2000)
	if gc>0 then
		Duel.Recover(p,200*gc,REASON_EFFECT)
	end
end
function c11478404.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c11478404.tdfilter(c)
	return c:IsSetCard(0xf2000) and not c:IsCode(11478404) and c:IsAbleToDeck()
end
function c11478404.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c11478404.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c11478404.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11478404.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11478404.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end