--Garbage Sword Collector
function c344000009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c344000009.value)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c344000009.val)
	c:RegisterEffect(e2)
end
function c344000009.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x444) or c:IsCode(44682448) or c:IsCode(18698739))
end
function c344000009.value(e,c)
	return Duel.GetMatchingGroupCount(c344000009.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*400
end
function c344000009.val(e,c)
	return c:GetEquipCount()*300
end
