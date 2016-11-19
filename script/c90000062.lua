--Royal Raid HP
function c90000062.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Activate Spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetTarget(c90000062.target)
	c:RegisterEffect(e1)
	--Activate Trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c90000062.target)
	c:RegisterEffect(e2)
	--Race Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c90000062.condition)
	e3:SetValue(RACE_MACHINE)
	c:RegisterEffect(e3)
end
function c90000062.target(e,c)
	return c:IsSetCard(0x1c)
end
function c90000062.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1c)
end
function c90000062.condition(e)
	return Duel.IsExistingMatchingCard(c90000062.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end