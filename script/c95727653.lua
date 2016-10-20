--Recycle
function c95727653.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c95727653.condition)
	e1:SetCost(c95727653.cost)
	e1:SetTarget(c95727653.target)
	e1:SetOperation(c95727653.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function c95727653.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c95727653.cfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function c95727653.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95727653.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c95727653.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c95727653.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c95727653.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end