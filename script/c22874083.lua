--I Call Your Name
function c22874083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22874083,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22874083)
	e1:SetCondition(c22874083.condition)
	e1:SetTarget(c22874083.target)
	e1:SetOperation(c22874083.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22874083,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22874083)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22874083.thcost)
	e2:SetTarget(c22874083.thtg)
	e2:SetOperation(c22874083.thop)
	c:RegisterEffect(e2)
end
function c22874083.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c22874083.thfilter1(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(5) and c:IsAttackBelow(1000) and not c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c22874083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c22874083.thfilter1,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c22874083.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22874083.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c22874083.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22874083.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and c:IsAbleToHand()
end
function c22874083.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22874083.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22874083.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22874083.thfilter2,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c22874083.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end