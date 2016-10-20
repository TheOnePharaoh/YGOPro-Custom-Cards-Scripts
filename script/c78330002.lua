--AB Leaf
function c78330002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,78330002)
	e1:SetCondition(c78330002.spcon)
	c:RegisterEffect(e1)
end
function c78330002.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xac9812) and not c:IsCode(78330002)
end
function c78330002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c78330002.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end