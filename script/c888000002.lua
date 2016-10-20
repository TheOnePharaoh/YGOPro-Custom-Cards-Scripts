--Evil HERO Elementum
function c888000002.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,21844576,58932615,84327329,79979666,true,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c888000002.splimit)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(0xf)
	c:RegisterEffect(e3)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000002,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c888000002.retcon)
	e4:SetTarget(c888000002.rettg)
	e4:SetOperation(c888000002.retop)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(888000002,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c888000002.retcon)
	e5:SetCost(c888000002.fuscost)
	e5:SetTarget(c888000002.fustg)
	e5:SetOperation(c888000002.fusop)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c888000002.val)
	c:RegisterEffect(e6)
end
c888000002.dark_calling=true
function c888000002.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000002.retcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c888000002.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c888000002.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c888000002.atkfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c888000002.val(e,c)
	return Duel.GetMatchingGroupCount(c888000002.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,c:GetAttribute())*300
end
function c888000002.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c888000002.fusfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL)
		and ((c:IsSetCard(0x46) and c:GetCode()~=23557835 and c:GetCode()~=27967615 and c:GetCode()~=37684215 and c:GetCode()~=49469105 
		and c:GetCode()~=95286165 and c:GetCode()~=100005002) or c:IsCode(23299957) or c:IsCode(12071500) or c:IsCode(37630732) 
		or c:IsCode(71490127) or c:IsCode(80033124) or c:IsCode(100000024))
end
function c888000002.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c888000002.fusfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c888000002.fusfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c888000002.fusop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c888000002.fusfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end