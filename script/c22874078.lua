--Vocalist's Call
function c22874078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22874078)
	e1:SetCondition(c22874078.condition)
	e1:SetTarget(c22874078.target)
	e1:SetOperation(c22874078.activate)
	c:RegisterEffect(e1)
end
function c22874078.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c22874078.filter(c,def)
	return c:IsSetCard(0x0dac405) and c:IsDefenseBelow(def) and c:IsAbleToHand()
end
function c22874078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsOnField() and not at:IsRace(RACE_MACHINE) and at:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c22874078.filter,tp,LOCATION_DECK,0,1,nil,at:GetAttack()) end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22874078.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() then
		local val=tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c22874078.filter,tp,LOCATION_DECK,0,1,1,nil,val)
		local sc=g1:GetFirst()
		if sc then
			val=val-sc:GetDefense()
			if Duel.IsExistingMatchingCard(c22874078.filter,tp,LOCATION_DECK,0,1,sc,val)
				and Duel.SelectYesNo(tp,aux.Stringid(22874078,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,c22874078.filter,tp,LOCATION_DECK,0,1,1,sc,val)
				g1:Merge(g2)
			end
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c22874078.sumlimit)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c22874078.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x0dac402)
end
