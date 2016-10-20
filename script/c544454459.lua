--Malefic Knight Master Diamond (ANIME)
function c544454459.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454459.spcon)
	e1:SetOperation(c544454459.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454459.descon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c544454459.destarget)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(544454459,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c544454459.sptg)
	e4:SetOperation(c544454459.spop2)
	c:RegisterEffect(e4)
end
function c544454459.spfilter(c)
	return c:IsCode(39512984) and c:IsAbleToRemoveAsCost()
end
function c544454459.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454459.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454459.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c544454459.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c544454459.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454459.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c544454459.filter(c,e,tp)
	return c:IsRace(RACE_ROCK) and c:GetCode()~=544454458
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c544454459.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454459.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c544454459.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c544454459.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end