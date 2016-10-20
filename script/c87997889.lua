--Malefic E. Hero Absolute Zero (ANIME)
function c87997889.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c87997889.spcon)
	e1:SetOperation(c87997889.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c87997889.descon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c87997889.destarget)
	c:RegisterEffect(e3)
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(87997889,0))
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_TO_GRAVE)
	e10:SetCondition(c87997889.descon2)
	e10:SetTarget(c87997889.destg)
	e10:SetOperation(c87997889.desop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e12)
	--atkup
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_UPDATE_ATTACK)
	e13:SetValue(c87997889.atkup)
	c:RegisterEffect(e13)
end
function c87997889.spfilter(c)
	return c:IsCode(40854197) and c:IsAbleToRemoveAsCost()
end
function c87997889.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c87997889.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c87997889.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c87997889.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c87997889.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c87997889.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c87997889.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x23) and c:GetCode()~=87997888 and c:GetCode()~=87997889
end
function c87997889.atkup(e,c)
	return Duel.GetMatchingGroupCount(c87997889.atkfilter,c:GetControler(),LOCATION_HAND,0,nil)*500
end
function c87997889.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c87997889.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c87997889.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
