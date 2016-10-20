--Irkex the Mystical Lost Son
function c89990009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x22b),4,2)
	c:EnableReviveLimit()
	--destroy s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c89990009.cost)
	e1:SetTarget(c89990009.target)
	e1:SetOperation(c89990009.operation)
	c:RegisterEffect(e1)
	--back to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(511001776,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(89990009)
	e2:SetCondition(c89990009.tdcon)
	e2:SetTarget(c89990009.tdtg)
	e2:SetOperation(c89990009.tdop)
	c:RegisterEffect(e2)
end
function c89990009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c89990009.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c89990009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c89990009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c89990009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c89990009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c89990009.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.RaiseSingleEvent(e:GetHandler(),89990009,e,r,rp,ep,ev)
	end
end
function c89990009.tdfilter(c)
	return c:IsSetCard(0x22b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() 
		and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) 
end
function c89990009.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(89990018)
end
function c89990009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c89990009.tdfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c89990009.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c89990009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
