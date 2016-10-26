--Royal Raid Aircraft
function c90000049.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c90000049.condition)
	c:RegisterEffect(e1)
end
function c90000049.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1c)
end
function c90000049.condition(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000049.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end