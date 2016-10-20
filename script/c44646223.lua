--Vocaloid Luo Tianyi/Modified
function c44646223.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c44646223.efilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c44646223.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c44646223.efilter(e,c)
	return c:IsFaceup() and c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228)
end