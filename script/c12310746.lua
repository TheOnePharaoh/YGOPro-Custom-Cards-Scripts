--Grave of Artorias
function c12310746.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12310746+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12310746.target)
	e1:SetOperation(c12310746.activate)
	c:RegisterEffect(e1)
end
function c12310746.tgfilter(c)
	return (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)) and c:IsAbleToGrave() 
end
function c12310746.tgfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToGrave() 
end
function c12310746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310746.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12310746.thfilter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310746.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12310746.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		return
	end
	if tc:IsLocation(LOCATION_GRAVE) and tc:IsRace(RACE_WARRIOR) and tc:IsType(TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(c12310746.tgfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(12310746,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c12310746.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
	if tc:IsLocation(LOCATION_GRAVE) and tc:IsRace(RACE_SPELLCASTER) and tc:IsType(TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(c12310746.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(12310746,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c12310746.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end