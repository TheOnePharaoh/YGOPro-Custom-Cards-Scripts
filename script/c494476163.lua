function c494476163.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c494476163.cost)
	e1:SetTarget(c494476163.target)
	e1:SetOperation(c494476163.activate)
	c:RegisterEffect(e1)
end
function c494476163.costfilter(c)
  return c:IsSetCard(0x0600) or c:IsSetCard(0x601) and c:IsDiscardable()
end

function c494476163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c494476163.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c494476163.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c494476163.tgfilter(c)
	return c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) and c:IsAbleToHand() and c:IsSetCard(0x600) or c:IsSetCard(0x601)
end
function c494476163.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c494476163.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c494476163.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c494476163.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c494476163.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
