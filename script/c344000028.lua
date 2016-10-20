
function c344000028.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(344000028,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c344000028.con)
	e1:SetTarget(c344000028.tg)
	e1:SetOperation(c344000028.op)
	c:RegisterEffect(e1)
end
function c344000028.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c344000028.filter(c)
	return c:IsSetCard(0x444a) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c344000028.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x14) and chkc:IsControler(tp) and c344000028.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c344000028.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c344000028.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c344000028.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
