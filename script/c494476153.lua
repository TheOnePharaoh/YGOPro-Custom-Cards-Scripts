function c494476153.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c494476153.spcon)
	c:RegisterEffect(e1)
end

function c494476153.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0600) and c:GetCode()~=494476153 and c:GetLevel()==8 or c:GetRank()==8
end
function c494476153.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c494476153.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end