--Dark Storm of Mysticism
function c89990002.initial_effect(c)
	--activate and cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c89990002.condition)
	e1:SetCost(c89990002.cost)
	e1:SetTarget(c89990002.target)
	e1:SetOperation(c89990002.operation)
	c:RegisterEffect(e1)
end
function c89990002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b)
end
function c89990002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c89990002.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c89990002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c89990002.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c89990002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c89990002.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c89990002.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c89990002.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c89990002.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
