--AB blitzer
function c78330004.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c78330004.cost)
	e1:SetTarget(c78330004.target)
	e1:SetOperation(c78330004.operation)
	c:RegisterEffect(e1)
	--Protect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330004,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,78330004)
	e2:SetCost(c78330004.incost)
	e2:SetTarget(c78330004.intg)
	e2:SetOperation(c78330004.inop)
	c:RegisterEffect(e2)
end
function c78330004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c78330004.filter(c)
	return c:GetCode()==78330015 and c:IsAbleToHand()
end
function c78330004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c78330004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78330004.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c78330004.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c78330004.incost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c78330004.infilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c78330004.intg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c78330004.infilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78330004.infilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c78330004.infilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c78330004.inop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c78330004.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c78330004.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
