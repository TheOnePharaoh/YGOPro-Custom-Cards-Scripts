--Paranoia - Song of False Hope and Betrayal
function c78360182.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c78360182.condition)
	e1:SetCost(c78360182.cost)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c78360182.tgtg)
	e2:SetValue(c78360182.atkval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c78360182.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c78360182.descon)
	c:RegisterEffect(e4)
end
function c78360182.confilter(c)
	return c:IsFaceup() and c:IsCode(77662930)
end
function c78360182.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78360182.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78360182.costfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function c78360182.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78360182.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c78360182.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c78360182.tgtg(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c78360182.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c78360182.atkval(e,c)
	return Duel.GetMatchingGroupCount(c78360182.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c78360182.chafilter(c)
	return c:IsFaceup() and c:IsCode(77662930)
end
function c78360182.descon(e)
	return not Duel.IsExistingMatchingCard(c78360182.chafilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end