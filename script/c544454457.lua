--Malefic Red Dragon Archfiend (ANIME)
function c544454457.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454457.spcon)
	e1:SetOperation(c544454457.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454457.descon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c544454457.destarget)
	c:RegisterEffect(e3)
end
function c544454457.spfilter(c)
	return c:IsCode(70902743) and c:IsAbleToRemoveAsCost()
end
function c544454457.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454457.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454457.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c544454457.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c544454457.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454457.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
