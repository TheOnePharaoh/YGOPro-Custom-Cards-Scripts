--Siegmeyer the Brave
--lua script by SGJin
function c12310753.initial_effect(c)
	aux.EnableDualAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(aux.IsDualState)
	c:RegisterEffect(e1)
	--change base attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(2300)
	c:RegisterEffect(e2)
end