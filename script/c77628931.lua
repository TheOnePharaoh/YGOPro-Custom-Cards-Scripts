--Grimm, Messenger of the Black Art
function c77628931.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628931,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c77628931.condition)
	e2:SetCost(c77628931.cost)
	e2:SetTarget(c77628931.target)
	e2:SetOperation(c77628931.operation)
	c:RegisterEffect(e2)
	--salvate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628931,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1)
	e3:SetCondition(c77628931.ddcon)
	e3:SetTarget(c77628931.ddtg)
	e3:SetOperation(c77628931.ddop)
	c:RegisterEffect(e3)
end
function c77628931.cfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628931.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c77628931.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c77628931.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77628931.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsAbleToGrave()
end
function c77628931.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628931.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c77628931.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628931.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c77628931.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function c77628931.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628931.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c77628931.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628931.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,2,2,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
