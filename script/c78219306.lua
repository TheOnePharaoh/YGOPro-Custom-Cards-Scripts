--Colossal Warrior - Ranger
function c78219306.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c78219306.repcon)
	e1:SetOperation(c78219306.repop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219306,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c78219306.target)
	e2:SetOperation(c78219306.operation)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetOperation(c78219306.recop)
	c:RegisterEffect(e3)
end
function c78219306.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219306.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219306,e,0,tp,0,0)
end
function c78219306.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219306.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219306.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219306.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+78219306,e,0,tp,0,0)
	end
end
function c78219306.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.Recover(tp,800,REASON_EFFECT)
end
