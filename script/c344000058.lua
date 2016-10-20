function c344000058.initial_effect(c)
	--atkdef up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(344000058,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c344000058.con)
	e1:SetOperation(c344000058.op)
	c:RegisterEffect(e1)
end
function c344000058.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAttribute(ATTRIBUTE_WIND)
end
function c344000058.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
end

