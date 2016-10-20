--Revival Ceremony from the Future
function c99199045.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99199045,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37803970)
	e1:SetCondition(c99199045.condition)
	e1:SetTarget(c99199045.target1)
	e1:SetOperation(c99199045.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199045,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,37803970)
	e2:SetCondition(c99199045.condition)
	e2:SetTarget(c99199045.target2)
	e2:SetOperation(c99199045.activate2)
	c:RegisterEffect(e2)
	--Activate3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199045,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,37803970)
	e3:SetCondition(c99199045.condition)
	e3:SetTarget(c99199045.target3)
	e3:SetOperation(c99199045.activate3)
	c:RegisterEffect(e3)
end
function c99199045.thfilter1(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99199045.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c99199045.thfilter1,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99199045.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c99199045.thfilter1,tp,LOCATION_DECK,0,nil)
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
function c99199045.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c99199045.thfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c99199045.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c99199045.thfilter2,tp,LOCATION_EXTRA,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c99199045.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c99199045.thfilter2,tp,LOCATION_EXTRA,0,nil)
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
function c99199045.thfilter3(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99199045.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c99199045.thfilter3,tp,LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c99199045.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c99199045.thfilter3,tp,LOCATION_GRAVE,0,nil)
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
