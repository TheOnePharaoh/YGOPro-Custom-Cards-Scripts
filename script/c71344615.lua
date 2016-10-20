--Vocaloid Emergency Call
function c71344615.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c71344615.condition)
	e1:SetTarget(c71344615.target)
	e1:SetOperation(c71344615.activate)
	c:RegisterEffect(e1)
end
function c71344615.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c71344615.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71344615.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c71344615.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71344615.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c71344615.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c71344615.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71344615.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71344615.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()~=1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
