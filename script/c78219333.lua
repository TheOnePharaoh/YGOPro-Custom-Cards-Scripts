--Clash of the Colossal Warrior
function c78219333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1,78219333)
	e1:SetCondition(c78219333.condition)
	e1:SetTarget(c78219333.target)
	e1:SetOperation(c78219333.activate)
	c:RegisterEffect(e1)
end
function c78219333.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c78219333.filter(c)
	return c:IsFaceup() and not c:IsCode(78219333) and c:IsCanAddCounter(0x1115,2)
end
function c78219333.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c78219333.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78219333.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(78219333,1))
	Duel.SelectTarget(tp,c78219333.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1115)
end
function c78219333.tfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7ad30) and c:IsAbleToHand()
end
function c78219333.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x1115,2) then
		local th=Duel.GetFirstMatchingCard(c78219333.tfilter,tp,LOCATION_DECK,0,nil)
		if th and Duel.SelectYesNo(tp,aux.Stringid(78219333,0)) then
			Duel.SendtoHand(th,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,th)
		end
	end
end
