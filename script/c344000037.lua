function c344000037.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,344000013,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,false,false)
end
