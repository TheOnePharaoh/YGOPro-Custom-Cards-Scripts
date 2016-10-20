function c344000014.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsSetCard,0x444a),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c344000014.target)
	e1:SetOperation(c344000014.operation)
	c:RegisterEffect(e1)
end
function c344000014.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c344000014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c344000014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c344000014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c344000014.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetFirst():IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	end
end
function c344000014.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local atk=tc:IsFaceup() and tc:GetAttack() or 0
		Duel.Recover(tp,atk,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
