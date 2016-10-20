--Divine Spring 
function c11478415.initial_effect(c)
	c:SetUniqueOnField(1,0,11478415)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478415,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c11478415.thcon)
	e2:SetTarget(c11478415.thtg)
	e2:SetOperation(c11478415.thop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c11478415.sdcon)
	c:RegisterEffect(e3)
	--search or discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11478415,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,11478415)
	e4:SetCondition(c11478415.dscon)
	e4:SetTarget(c11478415.dstg)
	e4:SetOperation(c11478415.dsop)
	c:RegisterEffect(e4)
end
function c11478415.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf2002)
end
function c11478415.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_RITUAL and eg:GetFirst():IsControler(tp) and eg:IsExists(c11478415.filter,1,nil)
end
function c11478415.thfilter(c)
	return c:IsSetCard(0xf2000) and c:IsAbleToHand()
end
function c11478415.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478415.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11478415.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478415.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11478415.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c11478415.sdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and not Duel.IsExistingMatchingCard(c11478415.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11478415.dscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp~=tp and c:IsReason(REASON_DESTROY)
end
function c11478415.dsfilter(c)
	return c:IsSetCard(0xf2002) and c:IsType(TYPE_RITUAL) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c11478415.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478415.dsfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11478415.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478415.dsfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(11478415,2))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
