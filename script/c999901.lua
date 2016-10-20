--Soldier of the Red Dragon
function c999901.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999901,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,999901)
	e1:SetCondition(c999901.spcon)
	e1:SetTarget(c999901.sptg)
	e1:SetOperation(c999901.spop)
	c:RegisterEffect(e1)
end
function c999901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1045)
end
function c999901.spfilter(c,e,tp)
	return c:IsSetCard(0x1045) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c999901.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c999901.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999901.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
