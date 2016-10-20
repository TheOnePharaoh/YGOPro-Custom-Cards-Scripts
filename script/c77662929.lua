--Vocaloid Macne Nana
function c77662929.initial_effect(c)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetCondition(c77662929.lvcon)
	e1:SetValue(6)
	c:RegisterEffect(e1)
	--eff gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77662929.effcon)
	e2:SetOperation(c77662929.effop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c77662929.lvcon)
	c:RegisterEffect(e3)
end
function c77662929.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:GetLevel()==3
end
function c77662929.lvcon(e)
	return Duel.IsExistingMatchingCard(c77662929.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c77662929.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c77662929.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--cannot chain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77662929,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77662929.limcon)
	e1:SetOperation(c77662929.limop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2)
	--cannot chain resolve
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77662929,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(c77662929.limop2)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3)
end
function c77662929.limfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:GetSummonPlayer()==tp
end
function c77662929.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77662929.limfilter,1,nil,tp)
end
function c77662929.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c77662929.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(77662929,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c77662929.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(77662929)~=0 then
		Duel.SetChainLimitTillChainEnd(c77662929.chainlm)
	end
	e:GetHandler():ResetFlagEffect(77662929)
end
function c77662929.chainlm(e,rp,tp)
	return tp==rp
end