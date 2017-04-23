--March of the Dead
function c77628960.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c77628960.condition)
	e1:SetTarget(c77628960.target)
	e1:SetOperation(c77628960.activate)
	c:RegisterEffect(e1)
end
function c77628960.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628960.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628960.grafilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c77628960.spfilter(c,e,tp)
	return c:IsSetCard(0xba003) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628960.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c77628960.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return ft>0 and g:CheckWithSumEqual(Card.GetLevel,7,1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77628960.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c77628960.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,7,1,ft)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
