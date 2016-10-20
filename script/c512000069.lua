--Tyrant Force
function c512000069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c512000069.activate)
	c:RegisterEffect(e1)
end
function c512000069.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c512000069.damcon)
	e3:SetOperation(c512000069.damop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c512000069.cfilter(c,tp)
	return c:GetPreviousControler()==1-tp and bit.band(c:GetReason(),0x41)==0x41
end
function c512000069.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c512000069.cfilter,1,nil,tp)
end
function c512000069.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c512000069.cfilter,nil,tp)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
