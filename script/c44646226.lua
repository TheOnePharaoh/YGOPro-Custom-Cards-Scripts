--Chrismast gift
function c44646226.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44646226,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,44646226+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c44646226.cost)
	e1:SetTarget(c44646226.target)
	e1:SetOperation(c44646226.operation)
	c:RegisterEffect(e1)
end
function c44646226.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c44646226.filter(c)
	return c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c44646226.filter2(c)
	return c:IsCode(44646214) and c:IsType(TYPE_TRAP) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c44646226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44646226.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44646226.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44646226.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g=Duel.GetMatchingGroup(c44646226.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(44646226,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
