--Vocaloid Acme Iku
function c9234501.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9234501,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9234501)
	e1:SetTarget(c9234501.target)
	e1:SetOperation(c9234501.operation)
	c:RegisterEffect(e1)
end
function c9234501.filter(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9234501.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c9234501.scfilter(c,mg)
	return c:IsSetCard(0x0dac402) and c:IsSynchroSummonable(nil,mg)
end
function c9234501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9234501.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9234501.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9234501.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9234501.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return end
	if not c:IsRelateToEffect(e) then return end
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c9234501.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
