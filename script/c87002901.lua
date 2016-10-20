--May-Raias King
function c87002901.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c87002901.hspcon)
	e2:SetOperation(c87002901.hspop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(87002901,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,87002901+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c87002901.spcon)
	e4:SetTarget(c87002901.sptg)
	e4:SetOperation(c87002901.spop)
	c:RegisterEffect(e4)
end
function c87002901.hspfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe291ca) and c:IsAbleToRemoveAsCost()
end
function c87002901.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87002901.hspfilter,c:GetControler(),LOCATION_GRAVE,0,5,nil)
end
function c87002901.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c87002901.hspfilter,c:GetControler(),LOCATION_GRAVE,0,5,5,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c87002901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c87002901.specfilter(c,e,tp)
	return c:GetCode()==87002902 
end
function c87002901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c87002901.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002901.specfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
