function c344000036.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,344000022,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,false,false)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end



