--Vocaloid Len Kagamine - Servant of Evil
function c87212677.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsCode,61352035))
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c87212677.con)
	e3:SetValue(c87212677.efilter)
	c:RegisterEffect(e3)
end
function c87212677.filter(c)
	return c:IsFaceup() and c:IsCode(7221167)
end
function c87212677.con(e)
	return Duel.IsExistingMatchingCard(c87212677.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		or Duel.IsEnvironment(7221167)
end
function c87212677.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
