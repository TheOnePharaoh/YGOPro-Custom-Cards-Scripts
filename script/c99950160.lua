--MSMM - Duelist's Sonata
function c99950160.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c99950160.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(99950160,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c99950160.atktg)
    e2:SetOperation(c99950160.atkop)
    c:RegisterEffect(e2)
end
function c99950160.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99950160.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c99950160.filter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(99950160,0)) then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local tc2=g:Select(1-tp,1,1,nil)
    Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
	if Duel.IsChainDisablable(0) then
	Duel.NegateEffect(0)
	return end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c99950160.aclimit)
	e1:SetCondition(c99950160.actcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99950160.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99950160.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsControler(tp)
end
function c99950160.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and c99950160.cfilter(a,tp)
end
function c99950160.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(9995) and bit.band(c:GetType(),0x81)==0x81
end
function c99950160.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99950160.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99950160.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99950160.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950160.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(tc:GetAttack()/2)
	tc:RegisterEffect(e1)
	end
end