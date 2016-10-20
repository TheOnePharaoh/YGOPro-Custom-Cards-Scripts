--Temporal Truce
function c19007861.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19007861.cost)
	e1:SetTarget(c19007861.target)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c19007861.atktg)
	c:RegisterEffect(e3)
	--Pos Change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c19007861.postg)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
end
function c19007861.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c19007861.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c19007861.descon)
	e1:SetOperation(c19007861.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c19007861.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c19007861.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c19007861.atktg(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c19007861.postg(e,c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end