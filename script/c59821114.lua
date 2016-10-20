--Power Drain
function c59821114.initial_effect(c)
	c:SetUniqueOnField(1,0,59821114)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ATK Reduce
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c59821114.atkcost)
	e2:SetTarget(c59821114.atktg)
	e2:SetOperation(c59821114.atkop)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(59821114,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c59821114.descon)
	e3:SetTarget(c59821114.destg)
	e3:SetOperation(c59821114.desop)
	c:RegisterEffect(e3)
end
function c59821114.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2)
end
function c59821114.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821114.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c59821114.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SendtoExtraP(g,POS_FACEUP,REASON_EFFECT+REASON_COST)
end
function c59821114.atkfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c59821114.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c59821114.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821114.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c59821114.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*-1)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c59821114.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c59821114.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c59821114.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(59821114,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_EFFECT) end
end