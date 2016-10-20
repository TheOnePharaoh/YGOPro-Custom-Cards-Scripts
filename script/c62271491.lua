--PoPiPo - Song of Protection
function c62271491.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac402))
	e2:SetValue(c62271491.efilter)
	c:RegisterEffect(e2)
end
function c62271491.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL)
end
