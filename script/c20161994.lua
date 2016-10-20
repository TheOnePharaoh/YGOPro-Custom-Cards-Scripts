--Lizardfolk - Runner
function c20161994.initial_effect(c)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20161994,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c20161994.tdcon)
	e1:SetTarget(c20161994.tdtg)
	e1:SetOperation(c20161994.tdop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20161994,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c20161994.reccon)
	e2:SetTarget(c20161994.rectg)
	e2:SetOperation(c20161994.recop)
	c:RegisterEffect(e2)
end
function c20161994.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c20161994.tdfilter(c)
	return c:IsAbleToDeck()
end
function c20161994.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c20161994.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20161994.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20161994.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c20161994.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c20161994.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c20161994.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c20161994.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
end

