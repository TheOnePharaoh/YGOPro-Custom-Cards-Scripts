--Saphira - The Goddess of Void
function c34858530.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c34858530.ovfilter,aux.Stringid(34858530,1))
	c:EnableReviveLimit()
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c34858530.etcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c34858530.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e3:SetCost(c34858530.negcost)
	e3:SetTarget(c34858530.negtg)
	e3:SetOperation(c34858530.negop)
	c:RegisterEffect(e3)
end
function c34858530.xyzfilter(c)
	return c:IsType(TYPE_PENDULUM) or c:IsSetCard(0x20c5)
end
function c34858530.ovfilter(c)
	return c:IsFaceup() and c:IsCode(34858512) or c:IsCode(34858528) or c:IsCode(34858529)
end
function c34858530.etfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) 
end
function c34858530.etcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c34858530.etfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c34858530.atktg(e,c)
	return (c:IsSetCard(0x20c5) and not c:IsCode(34858530)) or c:IsCode(34858507) 
end
function c34858530.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c34858530.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c34858530.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	return Duel.IsExistingMatchingCard(c34858530.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetChainLimit(aux.FALSE)
end
function c34858530.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c34858530.filter,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c34858530.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c34858530.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end