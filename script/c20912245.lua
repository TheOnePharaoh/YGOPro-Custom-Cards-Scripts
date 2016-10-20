--Alicia
function c20912245.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e1:SetCondition(c20912245.condition)
	e1:SetValue(200)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e2:SetCondition(c20912245.condition)
	e2:SetValue(200)
	c:RegisterEffect(e2)
end
function c20912245.condition(e)
	return e:GetHandler():GetEquipCount()>0
end