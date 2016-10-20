--Dragonic Enforcer
function c103950030.initial_effect(c)

	--Negate Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950030,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103950030.discon)
	e1:SetCost(c103950030.discost)
	e1:SetTarget(c103950030.distg)
	e1:SetOperation(c103950030.disop)
	c:RegisterEffect(e1)
	
	--Extra Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950030,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c103950030.sumop)
	c:RegisterEffect(e2)
end

--Negate Trap condition
function c103950030.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckEvent(EVENT_SUMMON_SUCCESS)
			and ((re:GetActiveType()==TYPE_TRAP) or (re:GetActiveType()==TYPE_CONTINUOUS+TYPE_TRAP))
			and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end

--Negate Trap cost
function c103950030.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

--Negate Trap target
function c103950030.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

--Negate Trap operation
function c103950030.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--Extra Normal Summon filter
function c103950030.sumfilter(c)
	return c:IsRace(RACE_DRAGON) and (c:GetLevel() >= 5)
end

--Extra Normal Summon operation
function c103950030.sumop(e,tp,eg,ep,ev,re,r,rp)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c103950030.sumfilter))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end