--Summoner of the Black Art
function c77628918.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsSetCard,0xba003),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628918.splimit)
	c:RegisterEffect(e1)
	--protect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628918,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c77628918.effcon)
	e2:SetOperation(c77628918.effop)
	c:RegisterEffect(e2)
end
function c77628918.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c77628918.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77628918.efffilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c77628918.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77628918.efffilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(aux.tgval)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end