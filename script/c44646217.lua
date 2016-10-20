--Vocaloid Scrapyard
function c44646217.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c44646217.target)
	e1:SetOperation(c44646217.activate)
	c:RegisterEffect(e1)
end
function c44646217.filter(c)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE) or c:IsCode(44646214) or c:IsCode(44646217) or c:IsCode(44646225) or c:IsCode(44646227) or c:IsCode(44646229) or c:IsCode(44646230) or c:IsCode(44646218) or c:IsCode(44646224) and c:IsAbleToHand()
end
function c44646217.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44646217.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44646217.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44646217.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
