--Prognata the Mystical Guardian
function c89990021.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c89990021.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c89990021.poscon)
	e2:SetOperation(c89990021.posop)
	c:RegisterEffect(e2)
end
function c89990021.condition(e)
	return Duel.IsEnvironment(89990018)
end
function c89990021.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c89990021.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
