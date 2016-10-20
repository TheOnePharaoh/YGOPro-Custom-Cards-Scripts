--Dual Axe Bearer, Secret of the Black Art
function c77628938.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xba003),2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628938.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c77628938.atkup)
	c:RegisterEffect(e2)
	--anti destroy battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77628938.twicon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--anti destroy effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c77628938.twicon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c77628938.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628938.atkfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628938.atkup(e,c)
	return Duel.GetMatchingGroupCount(c77628938.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c77628938.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628938.twicon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c77628938.grafilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=3
end