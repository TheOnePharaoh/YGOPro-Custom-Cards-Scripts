--Leto the Enraging Monarch
function c32147690.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32147690,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c32147690.condition)
	e1:SetTarget(c32147690.target)
	e1:SetOperation(c32147690.operation)
	c:RegisterEffect(e1)
end
function c32147690.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c32147690.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c32147690.climit)
end
function c32147690.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function c32147690.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
