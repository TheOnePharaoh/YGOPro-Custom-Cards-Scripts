--Necromantic Rite
function c77777749.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--from deck to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(77777749,0))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,77777749)
	e2:SetCondition(c77777749.condition)
	e2:SetTarget(c77777749.target)
	e2:SetOperation(c77777749.operation)
	c:RegisterEffect(e2)
	--spell from grave to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,77777750)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c77777749.thcost)
	e3:SetTarget(c77777749.thtg)
	e3:SetOperation(c77777749.thop)
	c:RegisterEffect(e3)
end
function c77777749.gfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c77777749.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777749.gfilter,1,nil,tp)
end
function c77777749.thfilter(c)
	return c:IsSetCard(0x1c8)  and c:IsAbleToHand()
end
function c77777749.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c77777749.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777749.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77777749.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77777749.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c77777749.cstfilter(c)
	return c:IsSetCard(0x1c8) and c:IsType(TYPE_MONSTER)
end
function c77777749.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777749.cstfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,c77777749.cstfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c77777749.filter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function c77777749.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE+LOCATION_REMOVED and chkc:GetControler()==tp and c77777749.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777749.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77777749.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77777749.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
