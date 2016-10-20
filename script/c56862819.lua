--Append
function c56862819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c56862819.actcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac402))
	e2:SetValue(c56862819.indval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac402))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c56862819.descon)
	e4:SetOperation(c56862819.desop)
	c:RegisterEffect(e4)
end
function c56862819.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402)
end
function c56862819.indval(e,c)
	return not c:IsType(TYPE_SYNCHRO)
end
function c56862819.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c56862819.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c56862819.dfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_SYNCHRO)
end
function c56862819.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c56862819.dfilter,1,nil,tp)
end
function c56862819.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
