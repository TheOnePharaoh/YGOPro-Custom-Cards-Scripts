--Tuner Limit Releaser
function c19611792.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c19611792.condition)
	e1:SetTarget(c19611792.target)
	e1:SetOperation(c19611792.activate)
	c:RegisterEffect(e1)
end
function c19611792.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsOnField() and d and d:IsFaceup() and d:IsControler(tp) and d:IsSetCard(0x0dac405) and d:IsType(TYPE_TUNER)
end
function c19611792.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttacker():CreateEffectRelation(e)
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c19611792.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsFacedown() or not a:IsRelateToEffect(e) or d:IsFacedown() or not d:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(a:GetAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e1)
end
