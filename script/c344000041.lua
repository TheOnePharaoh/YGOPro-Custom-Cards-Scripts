function c344000041.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c344000041.spcon)
	c:RegisterEffect(e1)
end
function c344000041.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa444a)
end
function c344000041.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c344000041.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end