--Malefic Slifer the Sky Dragon
function c544454445.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c544454445.spcon)
	e1:SetOperation(c544454445.spop)
	c:RegisterEffect(e1)
	--only 1 can exists
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetCondition(c544454445.excon)
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
	e4:SetTarget(c544454445.sumlimit)
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
	e7:SetCondition(c544454445.descon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c544454445.destarget)
	c:RegisterEffect(e8)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c544454445.antarget)
	c:RegisterEffect(e8)
	--atk/def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(c544454445.adval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e10)
	--spson
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11)
	--to grave
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(10000020,0))
	e12:SetCategory(CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCondition(c544454445.tgcon)
	e12:SetTarget(c544454445.tgtg)
	e12:SetOperation(c544454445.tgop)
	c:RegisterEffect(e12)
end
function c544454445.sumlimit(e,c)
	return c:IsSetCard(0x23)
end
function c544454445.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c544454445.excon(e)
	return Duel.IsExistingMatchingCard(c544454445.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454445.spfilter(c)
	return c:IsCode(10000020) and c:IsAbleToRemoveAsCost()
end
function c544454445.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454445.spfilter,c:GetControler(),LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c544454445.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454445.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c544454445.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c544454445.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454445.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c544454445.antarget(e,c)
	return c~=e:GetHandler()
end
function c544454445.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c544454445.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
		and e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c544454445.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c544454445.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
