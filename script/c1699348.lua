--Sin Armed Dragon
function c1699348.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1699348.spcon)
	e1:SetOperation(c1699348.spop)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c1699348.excon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetTarget(c1699348.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c1699348.descon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c1699348.destarget)
	c:RegisterEffect(e8)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c1699348.antarget)
	c:RegisterEffect(e8)
	--spson
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(1699348,0))
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c1699348.descost)
	e10:SetTarget(c1699348.destg)
	e10:SetOperation(c1699348.desop)
	c:RegisterEffect(e10)
end
function c1699348.sumlimit(e,c)
	return c:IsSetCard(0x23)
end
function c1699348.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c1699348.excon(e)
	return Duel.IsExistingMatchingCard(c1699348.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c1699348.spfilter(c)
	return c:IsCode(59464593) and c:IsAbleToRemoveAsCost()
end
function c1699348.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1699348.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c1699348.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c1699348.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c1699348.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c1699348.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c1699348.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c1699348.antarget(e,c)
	return c~=e:GetHandler()
end
function c1699348.dfilter(c)
	return c:IsDestructable()
end
function c1699348.descostfilter(c)
	return c:IsSetCard(0x23) and c:IsDiscardable()
end
function c1699348.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1699348.descostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1699348.descostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c1699348.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1699348.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c1699348.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1699348.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1699348.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
