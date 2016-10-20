--Ancient Monolith
function c103950037.initial_effect(c)

	c:SetCounterLimit(0x13,3)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Add counters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950037,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c103950037.addcon)
	e2:SetOperation(c103950037.addop)
	c:RegisterEffect(e2)
	
	--Negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(103950037,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCost(c103950037.atkcost)
	e3:SetOperation(c103950037.atkop)
	c:RegisterEffect(e3)
	
	--Gain LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(103950037,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROY)
	e4:SetOperation(c103950037.desop)
	c:RegisterEffect(e4)
	
end

--Add counters condition
function c103950037.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c103950037.filter,tp,LOCATION_REMOVED,0,1,nil)
end

--Add counters filter
function c103950037.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

--Add counters operation
function c103950037.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local g=Duel.GetMatchingGroup(c103950037.filter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetAttribute)
	
	if c:GetCounter(0x13) + ct > 3 then ct = 3 - c:GetCounter(0x13) end
	
	if ct > 0 then c:AddCounter(0x13,ct) end
end

--Negate attack cost
function c103950037.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x13,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x13,1,REASON_COST)
end

--Negate attack operation
function c103950037.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

--Gain LP operation
function c103950037.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousControler()==tp and c:IsStatus(STATUS_ACTIVATED) then
		Duel.Recover(tp,c:GetCounter(0x13)*1000,REASON_EFFECT)
	end
end
