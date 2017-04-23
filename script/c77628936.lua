--Drach Khan, Abdomination of the Black Art
function c77628936.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),4,2)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77628936,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e1:SetCost(c77628936.cost)
	e1:SetTarget(c77628936.target1)
	e1:SetOperation(c77628936.operation1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(77628936,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e2:SetCost(c77628936.cost)
	e2:SetTarget(c77628936.target2)
	e2:SetOperation(c77628936.operation2)
	c:RegisterEffect(e2)
end
function c77628936.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77628936.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628936.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c77628936.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xba003) and c:IsAbleToHand()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c77628931.filter2(c)
	return c:IsSetCard(0xba003) and c:IsAbleToGrave()
end
function c77628936.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628936.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77628936.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77628936.filter2,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c77628936.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77628936,3))
	local g=Duel.SelectMatchingCard(tp,c77628936.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
