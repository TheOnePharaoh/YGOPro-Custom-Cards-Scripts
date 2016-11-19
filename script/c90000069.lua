--Empire Power Energy
function c90000069.initial_effect(c)
	--Ritual Summon
	aux.AddRitualProcGreater(c,c90000069.filter)
end
function c90000069.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x2d)
end