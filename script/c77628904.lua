--Venom Snare of the Black Art
function c77628904.initial_effect(c)
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
	e2:SetDescription(aux.Stringid(77628904,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c77628904.spcon)
	e2:SetCost(c77628904.spcost)
	e2:SetTarget(c77628904.sptg)
	e2:SetOperation(c77628904.spop)
	e2:SetValue(c77628904.valcheck)
	c:RegisterEffect(e2)
end
function c77628904.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0
end
function c77628904.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c77628904.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,71341529)==0 then
			Duel.RegisterFlagEffect(tp,71341529,RESET_CHAIN,0,1)
			c77628904[0]=Duel.GetMatchingGroupCount(c77628904.cfilter,tp,LOCATION_HAND,0,e:GetHandler())
			c77628904[1]=0
		end
		return c77628904[0]-c77628904[1]>=2
	end
	Duel.DiscardHand(tp,c77628904.cfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c77628904.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77628904.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77628904.valcheck(e)
	c77628904[1]=c77628904[1]+2
end
