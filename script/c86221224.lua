--Vocaloid Rin Khylin
function c86221224.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86221224,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c86221224.setcon)
	e2:SetOperation(c86221224.setop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c86221224.indcon)
	e3:SetOperation(c86221224.indop)
	c:RegisterEffect(e3)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	e4:SetCondition(c86221224.cscon)
	c:RegisterEffect(e4)
end
function c86221224.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c86221224.setfilter(c)
	return c:IsCode(80280737) or c:IsCode(80280739) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c86221224.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c86221224.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c86221224.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c86221224.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86221224,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c86221224.csfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c86221224.cscon(e)
	return Duel.IsExistingMatchingCard(c86221224.csfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
