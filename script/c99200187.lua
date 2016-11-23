--Dark Android Captain Skullface
function c99200187.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99200187.efilter)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c99200187.sumop)
	c:RegisterEffect(e2)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99200187,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c99200187.ntcon)
	e3:SetOperation(c99200187.ntop)
	c:RegisterEffect(e3)
end
function c99200187.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200187.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,99200187)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c99200187.extratarget))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,99200187,RESET_PHASE+PHASE_END,0,1)
end
function c99200187.extratarget(c)
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790)
end
function c99200187.ntfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0xda3790) and not c:IsCode(99200187)
end
function c99200187.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99200187.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99200187.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(99200151)
	c:RegisterEffect(e1)
end
