--Card from the Twilight Sky
function c55438822.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55438822,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,55438822)
	e1:SetCost(c55438822.cost)
	e1:SetTarget(c55438822.target1)
	e1:SetOperation(c55438822.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55438822,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,55438822)
	e2:SetCost(c55438822.cost)
	e2:SetTarget(c55438822.target2)
	e2:SetOperation(c55438822.activate2)
	c:RegisterEffect(e2)
end
function c55438822.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,3,nil) end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438822.filter1(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c55438822.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438822.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55438822.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55438822.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55438822.filter2(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(55438822) and c:IsAbleToHand()
end
function c55438822.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438822.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55438822.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55438822.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
