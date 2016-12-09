--Seafarer's Ultimate Fate
function c66666700.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66666700)
	e1:SetTarget(c66666700.target)
	e1:SetOperation(c66666700.activate)
	c:RegisterEffect(e1)
	
end

function c66666700.filter(c)
	return c:IsSetCard(0x669) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()
		and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c66666700.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c66666700.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666700.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66666700.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,c66666700.filter2,tp,LOCATION_DECK,0,1,1,nil)
			if ag:GetCount()>0 then
				Duel.SendtoHand(ag,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
			end
		end
	end
end
function c66666700.filter2(c)
	return c:IsSetCard(0x669) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
