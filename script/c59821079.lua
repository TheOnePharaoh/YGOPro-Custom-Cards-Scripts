--The Idol's Final Assault
function c59821079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,59821079)
	e1:SetCondition(c59821079.condition)
	e1:SetCost(c59821079.cost)
	e1:SetTarget(c59821079.target)
	e1:SetOperation(c59821079.activate)
	c:RegisterEffect(e1)
end
function c59821079.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and Duel.IsChainNegatable(ev)
		and Duel.GetTurnPlayer()~=tp
end
function c59821079.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsAbleToRemoveAsCost()
end
function c59821079.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821079.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c59821079.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c59821079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c59821079.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
