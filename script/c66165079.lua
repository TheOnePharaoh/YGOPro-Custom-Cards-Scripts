--The Overwhelming Power
function c66165079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c66165079.condition)
	e1:SetTarget(c66165079.target)
	e1:SetOperation(c66165079.activate)
	c:RegisterEffect(e1)
end
function c66165079.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsSetCard(0xea010) and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165079.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66165079.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c66165079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c66165079.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
