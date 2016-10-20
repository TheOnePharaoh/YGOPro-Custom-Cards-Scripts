--The Kryos' Ecounter
function c8722163.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c8722163.condition)
	e1:SetTarget(c8722163.target)
	e1:SetOperation(c8722163.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c8722163.handcon)
	c:RegisterEffect(e2)
end
function c8722163.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8722163.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8722163.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c8722163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c8722163.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c8722163.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xb1b32)
end
function c8722163.handcon(e)
	return Duel.IsExistingMatchingCard(c8722163.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end