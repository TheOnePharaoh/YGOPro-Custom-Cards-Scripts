--山
function c512000033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON+RACE_WINDBEAST+RACE_THUNDER))
	e2:SetValue(c512000033.val1)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c512000033.val2)
	c:RegisterEffect(e3)
end
function c512000033.val1(e,c)
	return c:GetAttack()*3/10
end
function c512000033.val2(e,c)
	return c:GetDefense()*3/10
end
