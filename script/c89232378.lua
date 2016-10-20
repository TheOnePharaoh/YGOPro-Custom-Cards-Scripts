--Vocaloid Kid Grovy March
function c89232378.initial_effect(c)
	c:SetUniqueOnField(1,0,89232378)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89232378,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetCountLimit(1,89232378)
	e2:SetCondition(c89232378.drcon)
	e2:SetCost(c89232378.drcost)
	e2:SetTarget(c89232378.drtg)
	e2:SetOperation(c89232378.drop)
	c:RegisterEffect(e2)
end
function c89232378.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c89232378.filter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and not c:IsPublic()
end
function c89232378.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c89232378.filter,1,nil) end
	local g=eg:Filter(c89232378.filter,nil)
	if g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
end
function c89232378.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c89232378.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
