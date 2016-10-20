--Hall of the Lost Souls
function c77628949.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(77628949,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1)
	e2:SetCondition(c77628949.spcon)
	e2:SetTarget(c77628949.sptg)
	e2:SetOperation(c77628949.spop)
	c:RegisterEffect(e2)
	--effect indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetCondition(c77628949.edcon)
	c:RegisterEffect(e4)
end
function c77628949.edfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628949.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c77628949.edfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=6
end
function c77628949.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_ZOMBIE)
end
function c77628949.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and eg:IsExists(c77628949.cfilter,1,nil)
end
function c77628949.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsSetCard(0xba003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628949.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c77628949.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77628949.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77628949.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
