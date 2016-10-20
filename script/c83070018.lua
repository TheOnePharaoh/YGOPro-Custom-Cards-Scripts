--Surprise Shuffle
function c83070018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c83070018.target)
	e1:SetOperation(c83070018.activate)
	c:RegisterEffect(e1)
end
function c83070018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x837)
end
function c83070018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c83070018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83070018.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c83070018.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c83070018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetOperation(c83070018.op)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c83070018.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
end
