--AB Mother
function c78330009.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c78330009.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330009,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c78330009.spcost)
	e2:SetTarget(c78330009.sptg)
	e2:SetOperation(c78330009.spop)
	c:RegisterEffect(e2)
end
function c78330009.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c78330009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c78330009.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xac9812) and not c:IsType(TYPE_XYZ) and not c:IsCode(78330009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78330009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c78330009.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c78330009.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c78330009.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c78330009.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
