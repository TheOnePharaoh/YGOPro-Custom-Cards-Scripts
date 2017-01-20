--Blessing of Dragon God
function c34858541.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c34858541.condition)
	e1:SetOperation(c34858541.operation)
	c:RegisterEffect(e1)
	--Prevent Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(c34858541.efilter)
	c:RegisterEffect(e2)
end
function c34858541.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToRemove() 
end
function c34858541.condition(e,c)
	return Duel.IsExistingMatchingCard(c34858541.cfilter,tp,LOCATION_ONFIELD,0,1,nil,3485834858510)
		and Duel.IsExistingMatchingCard(c34858541.cfilter,tp,LOCATION_ONFIELD,0,1,nil,34858539)
end
function c34858541.filter(c)
    return c:IsCode(3485834858510) and c:IsAbleToRemove()
end
function c34858541.operation(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():SetTurnCounter(0)
    local sg=Duel.GetMatchingGroup(c34858541.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c34858541.descon)
	e1:SetOperation(c34858541.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	c34858541[e:GetHandler()]=e1
end
function c34858541.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c34858541.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c34858541.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
	end
end