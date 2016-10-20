--Hydrush Gardener
function c83070006.initial_effect(c)
	--to deck & special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83070006,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,83070006+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c83070006.tdsptg)
	e1:SetOperation(c83070006.tdspop)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070006,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c83070006.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c83070006.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
end
function c83070006.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c83070006.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x837) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83070006.tdsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c83070006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83070006.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83070006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c83070006.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c83070006.tdspop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c83070006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,8307,tp,tp,false,false,POS_FACEUP)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
