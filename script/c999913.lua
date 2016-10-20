--Burning Red Dragon Archfiend
function c999913.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c999913.sfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999913,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,999913)
	e1:SetCost(c999913.cost)
	e1:SetTarget(c999913.target)
	e1:SetOperation(c999913.operation)
	c:RegisterEffect(e1)
end
function c999913.sfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c999913.costfilter(c)
	return c:IsSetCard(0x1045) and c:IsAbleToDeckOrExtraAsCost()
end
function c999913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999913.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c999913.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c999913.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c999913.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsAbleToDeck() then 
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
