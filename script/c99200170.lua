--Missile Barrage Attack
function c99200170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c99200170.condition)
	e1:SetTarget(c99200170.target)
	e1:SetOperation(c99200170.activate)
	c:RegisterEffect(e1)
end
function c99200170.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3790)
end
function c99200170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99200170.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c99200170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99200170.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
