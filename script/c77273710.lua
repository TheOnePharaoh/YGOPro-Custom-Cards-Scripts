--Starlight Evolution
function c77273710.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c77273710.limcon)
	e2:SetOperation(c77273710.limop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c77273710.atlimit)
	c:RegisterEffect(e5)
end
function c77273710.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c77273710.atlimit(e,c)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(c77273710.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end
function c77273710.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c77273710.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77273710.limfilter,1,nil,tp)
end
function c77273710.limop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetChainLimitTillChainEnd(c77273710.chlimit)
end
function c77273710.chlimit(e,ep,tp)
	return tp==ep
end
