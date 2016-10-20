--Forbidden Beast Nibunu
function c512000084.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000391,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c512000084.sumtg)
	e1:SetOperation(c512000084.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c512000084.cfilter(c)
	return c:IsFaceup() and c:IsCode(511000380)
end
function c512000084.spfilter(c,e,tp)
	return c:IsSetCard(0x201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and (Duel.IsExistingMatchingCard(c512000084.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or c:IsLocation(LOCATION_GRAVE))
end
function c512000084.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000084.spfilter,tp,0x13,0,1,nil,e,tp) end
	if Duel.IsExistingMatchingCard(c512000084.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c512000084.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c512000084.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
