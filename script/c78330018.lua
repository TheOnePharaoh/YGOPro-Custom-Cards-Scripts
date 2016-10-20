--Arch Blocker
function c78330018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c78330018.condition)
	e1:SetTarget(c78330018.target)
	e1:SetOperation(c78330018.activate)
	c:RegisterEffect(e1)
end
function c78330018.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xac9812)
end
function c78330018.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c78330018.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c78330018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c78330018.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
