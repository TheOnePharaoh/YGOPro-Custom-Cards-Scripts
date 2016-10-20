--Dark Android Striker
function c99200158.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99200158.efilter)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c99200158.actcon)
	e2:SetOperation(c99200158.actop)
	c:RegisterEffect(e2)
end
function c99200158.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c99200158.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xda3790)
end
function c99200158.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c99200158.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c99200158.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
