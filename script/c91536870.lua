--Vocaloid Bruno and Clara
function c91536870.initial_effect(c)
	c:SetUniqueOnField(1,0,91536870)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c91536870.spcon)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--ATK modify
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x0dac402))
	e3:SetValue(200)
	c:RegisterEffect(e3)
end
function c91536870.cfilter(tc)
	return tc and tc:IsFaceup()
end
function c91536870.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (c91536870.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) or c91536870.cfilter(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)))
end
