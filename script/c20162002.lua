--Lizardfolk - Sage
function c20162002.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20162002,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c20162002.thcon)
	e1:SetTarget(c20162002.thtg)
	e1:SetOperation(c20162002.thop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20162002,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c20162002.reccon)
	e2:SetTarget(c20162002.rectg)
	e2:SetOperation(c20162002.recop)
	c:RegisterEffect(e2)
end
function c20162002.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20162002.thfilter(c)
	return c:IsSetCard(0xab90) and not c:IsCode(20162002) and c:IsAbleToHand()
end
function c20162002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20162002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20162002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20162002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20162002.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c20162002.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c20162002.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
end
