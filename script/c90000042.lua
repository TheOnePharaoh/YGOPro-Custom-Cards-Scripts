--Toxic Level Adjuster Lady
function c90000042.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Level Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c90000042.target)
	e1:SetOperation(c90000042.operation)
	c:RegisterEffect(e1)
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c90000042.target2)
	e2:SetValue(c90000042.value)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90000042.condition)
	e3:SetTarget(c90000042.target3)
	e3:SetOperation(c90000042.operation2)
	c:RegisterEffect(e3)
end
function c90000042.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c90000042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000042.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c90000042.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(90000042,0))
	else op=Duel.SelectOption(tp,aux.Stringid(90000042,0),aux.Stringid(90000042,1)) end
	e:SetLabel(op)
end
function c90000042.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c90000042.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c90000042.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000042.filter2,1,nil,tp) end
	return true
end
function c90000042.value(e,c)
	return c90000042.filter(c,e:GetHandlerPlayer())
end
function c90000042.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90000042.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tp=e:GetHandlerPlayer()
	local ct=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then ct=ct+tc:GetLevel() end
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*125)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*125)
end
function c90000042.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end