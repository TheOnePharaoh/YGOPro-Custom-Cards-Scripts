--Lautrec the Embraced
--lua script by SGJin
function c12310754.initial_effect(c)
	aux.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310754,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsDualState)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTarget(c12310754.ztg)
	e1:SetOperation(c12310754.zop)
	c:RegisterEffect(e1)
end
function c12310754.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c12310754.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c12310754.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c12310754.filter,tp,0,LOCATION_SZONE,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12310754.zop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		tc:RegisterEffect(e2)
	end
end
