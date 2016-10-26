--Dark Slate Warrior
function c999102.initial_effect(c)
	--shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999102,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c999102.shcost)
	e1:SetTarget(c999102.shtg)
	e1:SetOperation(c999102.shop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999102,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,999102)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c999102.condition)
	e2:SetTarget(c999102.target)
	e2:SetOperation(c999102.operation)
	c:RegisterEffect(e2)
end
function c999102.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c999102.filter(c)
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
	if c:IsLocation(LOCATION_SZONE) then
		if c:GetSequence()<4 then return false end
	elseif not c:IsType(TYPE_MONSTER) then return false end
	return c:IsLevelBelow(4) and not c:IsCode(999102) and c:IsAbleToDeck()
end
function c999102.thfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999102.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999102.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function c999102.shop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999102.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	local cg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(c999102.thfilter,tp,LOCATION_DECK,0,nil)
	if dg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(999102,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=dg:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	else
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
	end
end
function c999102.cfilter(c)
	return c:IsFaceup() and c:IsCode(999101)
end
function c999102.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999102.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c999102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999102.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end