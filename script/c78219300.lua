--Colossal Warrior - Unmaned Gunpod
function c78219300.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c78219300.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219300,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,78219300)
	e2:SetCondition(c78219300.condition)
	e2:SetCost(c78219300.cost)
	e2:SetTarget(c78219300.target)
	e2:SetOperation(c78219300.operation)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c78219300.repcon)
	e3:SetOperation(c78219300.repop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c78219300.atkcon)
	e4:SetTarget(c78219300.atktg)
	e4:SetValue(1500)
	c:RegisterEffect(e4)
	--place2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c78219300.regop)
	c:RegisterEffect(e5)
end
function c78219300.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(78219300,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c78219300.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(78219300)~=0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c78219300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x7ad30) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x7ad30)
	Duel.Release(g,REASON_COST)
end
function c78219300.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219300.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219300.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219300.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219300.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
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
		Duel.RaiseEvent(tc,EVENT_CUSTOM+78219300,e,0,tp,0,0)
	end
end
function c78219300.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219300.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219300,e,0,tp,0,0)
end
function c78219300.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c78219300.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackBelow(2000)
end