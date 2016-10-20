--krostar
function c89990010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1)
	c:EnableReviveLimit()
	--sp summon negated
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--add tower
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c89990010.con)
	e2:SetTarget(c89990010.tg)
	e2:SetOperation(c89990010.op)
	c:RegisterEffect(e2)
	--shuffling
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c89990010.deckcon)
	e3:SetTarget(c89990010.decktg)
	e3:SetOperation(c89990010.deckop)
	c:RegisterEffect(e3)
end
function c89990010.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c89990010.filter(c)
	return c:IsCode(89990029) and c:IsAbleToHand()
end
function c89990010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c89990010.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c89990010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c89990010.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdgcon(e,tp,eg,ep,ev,re,r,rp) and Duel.IsEnvironment(89990018)
end
function c89990010.deckfilter(c)
	return c:IsSetCard(0x22b) and c:IsAbleToDeck() and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) 
end
function c89990010.decktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89990010.deckfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c89990010.deckfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c89990010.deckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
