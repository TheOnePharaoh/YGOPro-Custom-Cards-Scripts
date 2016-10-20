--Dark Android Nuker
function c99200157.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99200157.efilter)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c99200157.sumop)
	c:RegisterEffect(e2)
end
function c99200157.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200157.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,99200157)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xda3790))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,99200157,RESET_PHASE+PHASE_END,0,1)
end
