--Mechquipped Re-Call
function c19007851.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19007851.target)
	e1:SetOperation(c19007851.activate)
	c:RegisterEffect(e1)
end
function c19007851.filter1(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsAbleToHand()
end
function c19007851.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007851.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c19007851.filter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c19007851.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c19007851.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c19007851.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c19007851.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19007851.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
