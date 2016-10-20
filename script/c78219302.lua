--Colossal Warrior - Assaulter
function c78219302.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c78219302.repcon)
	e1:SetOperation(c78219302.repop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219302,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c78219302.target)
	e2:SetOperation(c78219302.operation)
	c:RegisterEffect(e2)
	--heal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c78219302.regcon)
	e3:SetOperation(c78219302.regop)
	c:RegisterEffect(e3)
end
function c78219302.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219302.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219302,e,0,tp,0,0)
end
function c78219302.tgfilter(c)
	return c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM)
end
function c78219302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219302.tgfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c78219302.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c78219302.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
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
		Duel.RaiseEvent(tc,78219302,e,0,tp,0,0)
	end
end
function c78219302.filter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x7ad30)
end
function c78219302.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c78219302.filter,1,nil) and tp~=rp
end
function c78219302.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+0x1fc0000+RESET_CHAIN)
	e1:SetCondition(c78219302.healcon)
	e1:SetOperation(c78219302.healop)
	c:RegisterEffect(e1)
end
function c78219302.healcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c78219302.healop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,78219302)
	Duel.Recover(tp,800,REASON_EFFECT)
end