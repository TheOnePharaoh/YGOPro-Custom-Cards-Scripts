--Vocaloid Kasane Ted
function c13870050.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c13870050.actcon)
	e2:SetOperation(c13870050.actop)
	c:RegisterEffect(e2)
	--make ATK 0
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13870050,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13870050.target)
	e3:SetOperation(c13870050.operation)
	c:RegisterEffect(e3)
end
function c13870050.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_SYNCHRO)
end
function c13870050.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c13870050.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c13870050.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c13870050.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c13870050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c13870050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13870050.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c13870050.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c13870050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
