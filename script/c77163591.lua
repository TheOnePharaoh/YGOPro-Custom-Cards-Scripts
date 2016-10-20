--Vocaloid Maika
function c77163591.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner,1)
	c:EnableReviveLimit()
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c77163591.valop)
	c:RegisterEffect(e1)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c77163591.valop(e,tp,eg,ep,ev,re,r,rp)
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
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
end