--The Authority of the Black Chaos
function c999105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999105.cost)
	e1:SetTarget(c999105.target)
	e1:SetOperation(c999105.activate)
	c:RegisterEffect(e1)
end
function c999105.cfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsDiscardable()
end
function c999105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999105.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c999105.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c999105.filter(c)
	return c:IsFaceup() and c:GetAttack()>=1500 and c:IsDestructable()
end
function c999105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999105.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c999105.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c999105.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c999105.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end
