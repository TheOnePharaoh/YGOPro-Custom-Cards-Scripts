--D.S. Sea Pseuora
function c29001793.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FISH),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c29001793.valop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c29001793.descon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c29001793.descon)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--nontuner
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_NONTUNER)
	e5:SetCondition(c29001793.descon)
	c:RegisterEffect(e5)
end
function c29001793.valop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO then return end
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetTextAttack()
		if tatk<0 then tatk=0 end
		atk=atk+tatk
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c29001793.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c29001793.descon(e)
	return Duel.IsExistingMatchingCard(c29001793.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end