--Reverse Blessing
function c44646224.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c44646224.actcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c44646224.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c44646224.mtop)
	c:RegisterEffect(e3)
end
function c44646224.cfilter(c)
	return c:IsFaceup() and c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(44646228)
end
function c44646224.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44646224.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c44646224.disable(e,c)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c44646224.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>2000 and Duel.SelectYesNo(tp,aux.Stringid(44646224,0)) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
