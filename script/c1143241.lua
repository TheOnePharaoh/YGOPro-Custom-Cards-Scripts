--End Point, ANTI-MATTER Erase
function c1143241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143241,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,1143241)
	e1:SetCondition(c1143241.condition)
	e1:SetCost(c1143241.cost)
	e1:SetTarget(c1143241.target)
	e1:SetOperation(c1143241.activate)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143241,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCountLimit(1,1143241)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c1143241.negcost)
	e2:SetOperation(c1143241.negop)
	c:RegisterEffect(e2)
	if not c1143241.global_check then
		c1143241.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143241))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143241.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c1143241.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDestructable()
end
function c1143241.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143241.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1143241.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c1143241.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c1143241.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c1143241.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c1143241.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c1143241.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1143241.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:GetActivateLocation()==LOCATION_HAND
end
