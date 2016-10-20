--Sakuya
function c20912247.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd0a2))
	e1:SetCondition(c20912247.sumcon)
	c:RegisterEffect(e1)
end
function c20912247.sumcon(e)
	return e:GetHandler():GetEquipCount()>0
end