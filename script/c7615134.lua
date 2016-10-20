--Vocaloid Haku Yowane
function c7615134.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c7615134.regop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
end
function c7615134.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,7615134)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac405))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,7615134,RESET_PHASE+PHASE_END,0,1)
end