--Hydrush Serpent
function c83070002.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--draw and shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83070002,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,8307002)
	e1:SetTarget(c83070002.drtg)
	e1:SetOperation(c83070002.drop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070002,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,83070002)
	e2:SetCondition(c83070002.tdcon)
	e2:SetTarget(c83070002.tdtg)
	e2:SetOperation(c83070002.tdop)
	c:RegisterEffect(e2)
end
function c83070002.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c83070002.filter(c)
	return c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c83070002.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c83070002.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c83070002.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function c83070002.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c83070002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c83070002.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,tc:GetOwner(),0)
	end
end
