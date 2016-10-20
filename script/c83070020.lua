--Hydrush Drain
function c83070020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c83070020.condition)
	e1:SetTarget(c83070020.target)
	e1:SetOperation(c83070020.activate)
	c:RegisterEffect(e1)
end
function c83070020.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c83070020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070014)
		and Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070015)
		and Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070016)
		and Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070017)
end
function c83070020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c83070020.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070014)
		or not Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070015)
		or not Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070016)
		or not Duel.IsExistingMatchingCard(c83070020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,83070017)
	then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
