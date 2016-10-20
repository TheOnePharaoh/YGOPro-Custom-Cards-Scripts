--Singing Passion of Vocaloids
function c38709246.initial_effect(c)
	c:SetUniqueOnField(1,0,38709246)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(c38709246.extratarget))
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c38709246.atktg)
	e3:SetValue(c38709246.atkval)
	c:RegisterEffect(e3)
end
function c38709246.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c38709246.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c38709246.atkval(e,c)
	return Duel.GetMatchingGroupCount(c38709246.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*100
end
function c38709246.extratarget(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405)
end