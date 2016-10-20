--Dungeon Master of the Black Art
function c77628911.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	c:SetUniqueOnField(1,0,77628911)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628911,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,77628911)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77628911.spcon)
	e2:SetTarget(c77628911.sptg)
	e2:SetOperation(c77628911.spop)
	c:RegisterEffect(e2)
	--spsummon count limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c77628911.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba003) and c:IsType(TYPE_FUSION)
end
function c77628911.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628911.spfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c77628911.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77628911.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end