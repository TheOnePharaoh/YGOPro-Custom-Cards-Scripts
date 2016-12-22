--Loli Emiko
function c56540053.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c56540053.spcon)
	c:RegisterEffect(e1)
	--immune trap
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS+EVENT_SUMMON_SUCCESS)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c56540053.efilter)
	c:RegisterEffect(e3)
end
function c56540053.efilter(e,te)
 return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c56540053.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
end
function c56540053.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c56540053.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
