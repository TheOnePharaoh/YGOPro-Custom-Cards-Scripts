--Vocaloid Akiko
function c84641209.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c84641209.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c84641209.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c84641209.spcon)
	e2:SetOperation(c84641209.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c84641209.indval)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,0xff)
	e4:SetValue(LOCATION_REMOVED)
	e4:SetTarget(c84641209.rmtg)
	c:RegisterEffect(e4)
end
function c84641209.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c84641209.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c84641209.spfilter1(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c84641209.spfilter2,1,c)
end
function c84641209.spfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial()
end
function c84641209.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c84641209.spfilter1,1,nil,tp)
end
function c84641209.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c84641209.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c84641209.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c84641209.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c84641209.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end