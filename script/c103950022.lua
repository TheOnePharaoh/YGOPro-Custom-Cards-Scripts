--Nemesis Dragion
function c103950022.initial_effect(c)

	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	
	--Unaffected by other monster's effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950022,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c103950022.value)
	c:RegisterEffect(e1)
	
	--Piercing damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950022,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end

--Unaffected by other monster's effects filter
function c103950022.value(e,te)
	return te:IsActiveType(TYPE_MONSTER) and
			(not te:GetHandler():IsLocation(LOCATION_MZONE) or
			(te:GetHandler():GetAttack() <= e:GetHandler():GetAttack() - 800))
end