--Malefic Armed Dragon (ANIME)
function c1699349.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1699349.spcon)
	e1:SetOperation(c1699349.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c1699349.descon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c1699349.destarget)
	c:RegisterEffect(e3)
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(1699349,0))
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c1699349.descost)
	e10:SetTarget(c1699349.destg)
	e10:SetOperation(c1699349.desop)
	c:RegisterEffect(e10)
end
function c1699349.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c1699349.spfilter(c)
	return c:IsCode(59464593) and c:IsAbleToRemoveAsCost()
end
function c1699349.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1699349.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c1699349.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c1699349.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c1699349.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c1699349.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c1699349.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c1699349.dfilter(c)
	return c:IsDestructable()
end
function c1699349.descostfilter(c)
	return c:IsSetCard(0x23) and c:IsDiscardable()
end
function c1699349.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1699349.descostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1699349.descostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c1699349.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1699349.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c1699349.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1699349.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1699349.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
