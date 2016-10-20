function c344000023.initial_effect(c)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c344000023.indval)
	c:RegisterEffect(e1)

end
function c344000023.indval(e,c)
	return c:IsLevelBelow(7)
end

