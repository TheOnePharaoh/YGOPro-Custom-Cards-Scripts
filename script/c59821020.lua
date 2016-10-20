--Light of the Idols
function c59821020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c59821020.target)
	e1:SetOperation(c59821020.activate)
	c:RegisterEffect(e1)
end
function c59821020.filter(c,e,tp)
	return c:IsSetCard(0xa1a2) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA+LOCATION_GRAVE) and c59821020.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c59821020.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c59821020.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c59821020.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
