--Black Iron Tarkus
--lua script by SGJin
function c12310709.initial_effect(c)
	aux.EnableDualAttribute(c)
	--XYZ Killer
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310709,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(aux.IsDualState)
	e1:SetCondition(c12310709.con)
	e1:SetOperation(c12310709.op)
	c:RegisterEffect(e1)
end
function c12310709.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetSummonLocation()==LOCATION_EXTRA and bc:GetAttack()>=2000
end
function c12310709.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
	end
end
