--Dance of Macabre
function c59821128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821128)
	e1:SetTarget(c59821128.target)
	e1:SetOperation(c59821128.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821128,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821128)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c59821128.thcost)
	e2:SetTarget(c59821128.thtg)
	e2:SetOperation(c59821128.thop)
	c:RegisterEffect(e2)
end
function c59821128.filter(c)
	return c:IsSetCard(0xa1a2) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
		and c:IsType(TYPE_PENDULUM) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c59821128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821128.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,5,nil) 
	and Duel.IsExistingMatchingCard(c59821128.filter2,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,0,0)
end
function c59821128.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821128.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g:GetCount()<5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,5,5,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c59821128.filter2,tp,LOCATION_DECK,0,2,2,nil)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end
function c59821128.filter2(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c59821128.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821128.thfilter2(c)
	return (c:IsSetCard(0x95) or c:IsSetCard(0x5D2)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c59821128.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821128.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c59821128.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c59821128.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
