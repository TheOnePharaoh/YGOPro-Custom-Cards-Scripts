--Agamus the Elementarist, 12th Arian Guardian
function c77790003.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,77790003)
	e1:SetTarget(c77790003.tg)
	e1:SetOperation(c77790003.op)
	c:RegisterEffect(e1)
	--draw and banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,77790003)
	e2:SetTarget(c77790003.target)
	e2:SetOperation(c77790003.activate)
	c:RegisterEffect(e2)
end
function c77790003.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsReason(REASON_DESTROY)
end
function c77790003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77790003.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c77790003.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77790003.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,tp,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c77790003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c77790003.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(1-p,0,LOCATION_HAND)
	Duel.ConfirmCards(1-p,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(1-p,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.ShuffleHand(p)
end
