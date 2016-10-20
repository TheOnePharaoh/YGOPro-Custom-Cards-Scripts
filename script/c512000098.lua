--Cemetery Change
function c512000098.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c512000098.condition)
	e1:SetCost(c512000098.cost)
	e1:SetTarget(c512000098.target)
	e1:SetOperation(c512000098.activate)
	c:RegisterEffect(e1)
end
function c512000098.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=15
end
function c512000098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c512000098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c512000098.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local g1=Duel.GetDecktopGroup(tp,ct1)
	local g2=Duel.GetDecktopGroup(1-tp,ct2)
	Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
	local gg1=Duel.GetMatchingGroup(c512000098.filter,tp,LOCATION_GRAVE,0,nil)
	local gg2=Duel.GetMatchingGroup(c512000098.filter,tp,0,LOCATION_GRAVE,nil)
	Duel.SendtoDeck(gg1,1-tp,0,REASON_EFFECT)
	Duel.SendtoDeck(gg2,tp,0,REASON_EFFECT)
	Duel.SwapDeckAndGrave(tp)
	Duel.SwapDeckAndGrave(1-tp)
	Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
	Duel.SendtoDeck(g2,nil,0,REASON_EFFECT)
end
