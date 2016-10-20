--Captain of the Black Art
function c77628910.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c77628910.chainop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c77628910.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c77628910.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0xba003) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c77628910.chainlm)
	end
end
function c77628910.chainlm(e,rp,tp)
	return tp==rp
end
function c77628910.tgtg(e,c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_FUSION)
end