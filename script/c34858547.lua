--Emergency Tactics
function c34858547.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c34858547.condition)
	e1:SetCost(c34858547.cost)
	e1:SetTarget(c34858547.target)
	e1:SetOperation(c34858547.activate)
	c:RegisterEffect(e1)
end
function c34858547.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c34858547.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c34858547.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and rp~=tp 
end
function c34858547.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34858547.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c34858547.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c34858547.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c34858547.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		e:GetHandler():CancelToGrave()
		Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(e:GetHandler():GetControler())
	end
end	