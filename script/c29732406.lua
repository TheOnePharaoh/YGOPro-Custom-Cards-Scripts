--B.M.I. Recovery Assistance
function c29732406.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29732406+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29732406.condition)
	e1:SetTarget(c29732406.target)
	e1:SetOperation(c29732406.operation)
	c:RegisterEffect(e1)
end
function c29732406.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:GetPreviousControler()==tp and c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c29732406.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c29732406.cfilter,nil,tp)
	return g:GetCount()==1
end
function c29732406.thfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29732406.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29732406.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29732406.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29732406.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(c29732406.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c29732406.indtg(e,c)
	return c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac402) or c:IsSetCard(0x0dac403) or c:IsSetCard(0x0dac404) or c:IsSetCard(0x0dac401) or c:IsSetCard(0x0dac405) or c:IsSetCard(0x301) or c:IsSetCard(0x0dac406)
end
