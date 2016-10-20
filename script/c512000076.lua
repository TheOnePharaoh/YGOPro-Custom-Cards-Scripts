--Overspeed
function c512000076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000076.target)
	e1:SetOperation(c512000076.activate)
	c:RegisterEffect(e1)
end
function c512000076.monfilter(c)
	local lv=c:GetLevel()
	return lv>0 and lv<4 and c:IsAbleToHand()
end
function c512000076.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c512000076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000076.monfilter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c512000076.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c512000076.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c512000076.monfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c512000076.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>1 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
