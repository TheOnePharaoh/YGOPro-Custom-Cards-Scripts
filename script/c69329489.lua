--Vocaloid Hatsune Miku - Hello Earth
function c69329489.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
end
