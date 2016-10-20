--Kokoro
function c11111136.initial_effect(c)
	c:SetUniqueOnField(1,0,11111136)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111136,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c11111136.thcon)
	e2:SetTarget(c11111136.thtg)
	e2:SetOperation(c11111136.thop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCondition(c11111136.tgcon)
	e3:SetTarget(c11111136.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c11111136.cofilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac401)
end
function c11111136.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_RITUAL and eg:GetFirst():IsControler(tp) and eg:IsExists(c11111136.cofilter,1,nil)
end
function c11111136.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c11111136.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x0dac406) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
function c11111136.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,1)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not tc1:IsSetCard(0x0dac401) or not tc2:IsSetCard(0x0dac401) then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==1 and scl2==7
end
function c11111136.tgtg(e,c)
	return c:IsSetCard(0x0dac401) and (c:GetSequence()==6 or c:GetSequence()==7)
end
