--Ladakhar the Mystical Knight
function c89990011.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(c89990011.condition)
	c:RegisterEffect(e1)
end
function c89990011.condition(e)
	return Duel.IsEnvironment(89990018)
end
