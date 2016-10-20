--True Name
function c512000038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000038.target)
	e1:SetOperation(c512000038.activate)
	c:RegisterEffect(e1)
end
function c512000038.spfilter(c,e,tp)
	return c:IsCode(10000040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000038.filter(c,code1,code2,code3)
	local code=c:GetOriginalCode()
	return c:IsReleasableByEffect() and (c:IsCode(code1) or code==code1 or code==code2 or code==code3)
end
function c512000038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 
		and Duel.IsExistingMatchingCard(c512000038.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(c512000038.filter,tp,LOCATION_MZONE,0,1,nil,10000010,110000010,51100236) 
		and Duel.IsExistingMatchingCard(c512000038.filter,tp,LOCATION_MZONE,0,1,nil,10000000,110000011,511000235) 
		and Duel.IsExistingMatchingCard(c512000038.filter,tp,LOCATION_MZONE,0,1,nil,10000020,110000012,511000238) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512000038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c512000038.filter,tp,LOCATION_MZONE,0,1,1,nil,10000010,110000010,51100236)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c512000038.filter,tp,LOCATION_MZONE,0,1,1,nil,10000000,110000011,511000235)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=Duel.SelectMatchingCard(tp,c512000038.filter,tp,LOCATION_MZONE,0,1,1,nil,10000020,110000012,511000238)
	g1:Merge(g2)
	g1:Merge(g3)
	local ct=Duel.Release(g1,REASON_EFFECT)
	if ct<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c512000038.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
