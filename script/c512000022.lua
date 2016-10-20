--Soul Connection
function c512000022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51200022+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c512000022.con)
	e1:SetTarget(c512000022.target)
	e1:SetOperation(c512000022.activate)
	c:RegisterEffect(e1)
end
function c512000022.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and ((ph==PHASE_MAIN1 and not Duel.CheckPhaseActivity()) or ph==PHASE_DRAW or ph==PHASE_STANDBY)
end
function c512000022.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c512000022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000022.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c512000022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c512000022.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
