--Anti-Magic Arrows
function c512000094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c512000094.condition)
	e1:SetTarget(c512000094.target)
	e1:SetOperation(c512000094.activate)
	c:RegisterEffect(e1)
end
function c512000094.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c512000094.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c512000094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000094.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c512000094.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c512000094.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c512000094.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
