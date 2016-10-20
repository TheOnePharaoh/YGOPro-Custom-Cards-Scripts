--Final Legacy of The Sword Arts
function c20912268.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c20912268.condition)
	e1:SetTarget(c20912268.target)
	e1:SetOperation(c20912268.activate)
	c:RegisterEffect(e1)
end
function c20912268.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_XYZ)
end
function c20912268.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20912268.cfilter,1,nil,tp)
end
function c20912268.filter(c,e,tp)
	return c:IsSetCard(0xd0a2) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912268.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20912268.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20912268.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20912268.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
