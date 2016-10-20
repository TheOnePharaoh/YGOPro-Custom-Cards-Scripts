--AB Lady
function c78330001.initial_effect(c)
	--salvate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330001,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c78330001.tgtg)
	e1:SetOperation(c78330001.tgop)
	c:RegisterEffect(e1)
end
function c78330001.tgfilter(c)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0xac9812)
end
function c78330001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c78330001.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78330001.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c78330001.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c78330001.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end