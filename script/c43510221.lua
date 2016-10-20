--Vocaloid Fighting Spirit
function c43510221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43510221)
	e1:SetTarget(c43510221.target)
	e1:SetOperation(c43510221.activate)
	c:RegisterEffect(e1)
end
function c43510221.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43510221.rmfilter(c)
	return c:IsAbleToGrave()
end
function c43510221.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c43510221.rmfilter,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingTarget(c43510221.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c43510221.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g2=Duel.SelectTarget(tp,c43510221.rmfilter,tp,0,LOCATION_HAND,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_HANDES,g2,1,0,0)
end
function c43510221.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_HANDES)
	if tg1:GetFirst():IsRelateToEffect(e) and tg1:GetFirst():IsRace(RACE_MACHINE) then
		Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoGrave(tg2,REASON_EFFECT+REASON_DISCARD)
	end
end
