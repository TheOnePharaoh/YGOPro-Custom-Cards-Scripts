--Double Discord
function c8099623.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c8099623.pietg)
	c:RegisterEffect(e2)
end
function c8099623.pietg(e,c)
	local code=c:GetCode()
	return code==5717743 or code==58431891 or code==86221218
end
function c8099623.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsControler(tp) and bc and bc:IsDefensePos() and tc:IsCode(86221218)
end