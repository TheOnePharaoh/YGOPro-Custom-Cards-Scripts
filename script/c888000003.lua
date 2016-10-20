--Evil HERO Darkius
function c888000003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000003.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c888000003.atkup)
	c:RegisterEffect(e2)
end
c888000003.dark_calling=true
function c888000003.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000003.atkup(e,c)
	return (Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,0x8)*100)+(Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,0x8)*200)
end
