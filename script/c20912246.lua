--egil
function c20912246.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20912246.spcon)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c20912246.condition)
	c:RegisterEffect(e2)
end
function c20912246.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2)
end
function c20912246.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0 and
		Duel.IsExistingMatchingCard(c20912246.filter,c:GetControler(),LOCATION_SZONE,0,2,nil)
end
function c20912246.condition(e)
	return e:GetHandler():GetEquipCount()>0
end