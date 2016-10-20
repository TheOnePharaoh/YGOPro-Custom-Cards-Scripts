--Imperial Red Dragon
function c999916.initial_effect(c)
	--redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1)
end
