--Shaddoll Chimra
function c98441210.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98441210,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98441210)
	e1:SetTarget(c98441210.target)
	e1:SetOperation(c98441210.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98441210,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,98441210)
	e2:SetCondition(c98441210.thcon)
	e2:SetTarget(c98441210.thtg)
	e2:SetOperation(c98441210.thop)
	c:RegisterEffect(e2)
end
function c98441210.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c98441210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c4929256.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98441210.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98441210.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98441210.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c98441210.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c98441210.tgfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9d) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c98441210.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c98441210.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c98441210.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98441210.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98441210.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98441210.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c98441210.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
