--Jack the Lantern Bearer, Commissioner of the Black Art
function c77628939.initial_effect(c)
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
	e2:SetDescription(aux.Stringid(77628939,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,77628939)
	e2:SetCondition(c77628939.condition1)
	e2:SetCost(c77628939.cost)
	e2:SetTarget(c77628939.target1)
	e2:SetOperation(c77628939.operation1)
	c:RegisterEffect(e2)
	--search2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628939,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,77628939)
	e3:SetCondition(c77628939.condition2)
	e3:SetCost(c77628939.cost)
	e3:SetTarget(c77628939.target2)
	e3:SetOperation(c77628939.operation2)
	c:RegisterEffect(e3)
end
function c77628939.grafilter1(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628939.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628939.grafilter1,tp,LOCATION_GRAVE,0,3,nil)
end
function c77628939.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77628939.filter1(c)
	return c:GetCode()==77628924 or c:GetCode()==4064256 and c:IsAbleToHand()
end
function c77628939.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628939.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77628939.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c77628939.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c77628939.grafilter2(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628939.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628939.grafilter2,tp,LOCATION_GRAVE,0,5,nil)
end
function c77628939.filter2(c)
	return c:GetCode()==77628920 or c:GetCode()==77628937 and c:IsAbleToHand()
end
function c77628939.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628939.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77628939.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c77628939.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end