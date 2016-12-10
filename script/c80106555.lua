--The Sacred Seal's Retribution
function c80106555.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80106555)
	e1:SetTarget(c80106555.target)
	e1:SetOperation(c80106555.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,80106555)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c80106555.drcost)
	e2:SetTarget(c80106555.tdtg)
	e2:SetOperation(c80106555.tdop)
	c:RegisterEffect(e2)
end
function c80106555.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0xca00)
end
function c80106555.sdcon(e)
	return Duel.IsExistingMatchingCard(c80106555.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local a=false
		local b=false
		if h1==0 then
			a=Duel.IsPlayerCanDraw(tp,1)
		elseif h1<3 then
			a=Duel.IsPlayerCanDraw(tp,h1)
		else
			a=Duel.IsPlayerCanDraw(tp,3)
		end
		if h2==0 then
			b=Duel.IsPlayerCanDraw(1-tp,1)
		elseif h2<3 then
			b=Duel.IsPlayerCanDraw(1-tp,h2)
		else
			b=Duel.IsPlayerCanDraw(1-tp,3)
		end
		return a and b
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c80106555.activate(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local turnp=Duel.GetTurnPlayer()
	local g1
	if h1==0 then
		h1=1
		g1=Group.CreateGroup()
	elseif h1<3 then
		g1=Duel.GetFieldGroup(turnp,LOCATION_HAND,0)
	else
		h1=3
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(turnp,aux.TRUE,turnp,LOCATION_HAND,0,3,3,nil)
	end
	Duel.ConfirmCards(1-turnp,g1)
	local g2
	if h2==0 then
		h2=1
		g2=Group.CreateGroup()
	elseif h2<3 then
		g2=Duel.GetFieldGroup(1-turnp,LOCATION_HAND,0)
	else
		h2=3
		Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(1-turnp,aux.TRUE,1-turnp,LOCATION_HAND,0,3,3,nil)
	end
	Duel.ConfirmCards(turnp,g2)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(turnp,h1,REASON_EFFECT)
	Duel.Draw(1-turnp,h2,REASON_EFFECT)
end
function c80106555.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80106555.tdfilter(c)
	return c:IsSetCard(0xca00) and not c:IsCode(80106555) and c:IsAbleToDeck()
end
function c80106555.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c63274863.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c80106555.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c80106555.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80106555.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end