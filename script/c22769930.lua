--Secret Deployment
function c22769930.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769930,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22769930.condition)
	e1:SetCost(c22769930.cost)
	e1:SetTarget(c22769930.target)
	e1:SetOperation(c22769930.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769930,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22769930)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22769930.thcost)
	e2:SetTarget(c22769930.thtg)
	e2:SetOperation(c22769930.thop)
	c:RegisterEffect(e2)
end
function c22769930.dfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaa12)
end
function c22769930.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22769930.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22769930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,4) end
	Duel.DiscardDeck(tp,4,REASON_COST)
end
function c22769930.filter(c,e,tp)
	return c:IsSetCard(0xaa12) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22769930.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22769930.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22769930.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22769930.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769930.thfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsSetCard(0xaa12) and c:IsAbleToHand()
end
function c22769930.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769930.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22769930.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22769930.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,210) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
	end
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end