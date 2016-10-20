--Baby Red Dragon
function c999906.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999906,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,999906+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c999906.spcost)
	e1:SetTarget(c999906.sptg)
	e1:SetOperation(c999906.spop)
	c:RegisterEffect(e1)
end
function c999906.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c999906.filter(c,e,tp)
	return c:IsCode(70902743) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999906.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 
		and Duel.IsExistingMatchingCard(c999906.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c999906.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c999906.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
