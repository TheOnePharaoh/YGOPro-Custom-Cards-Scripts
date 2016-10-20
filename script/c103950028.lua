--Soulbound Draco
function c103950028.initial_effect(c)

	--Cannot be Special Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950028,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	
	--Send replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950028,1))
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c103950028.reptgt)
	e1:SetOperation(c103950028.repop)
	c:RegisterEffect(e1)
	
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950028,2))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c103950028.spcon)
	e2:SetCost(c103950028.spcost)
	e2:SetTarget(c103950028.sptgt)
	e2:SetOperation(c103950028.spop)
	c:RegisterEffect(e2)
end

--Send replace target
function c103950028.reptgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_REMOVED) and c:IsReason(REASON_DESTROY) end
	
	return (Duel.GetLocationCount(tp,LOCATION_SZONE) > 0)
end

--Send replace operation
function c103950028.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end

--Special Summon condition
function c103950028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and e:GetHandler():IsType(TYPE_SPELL) and Duel.GetFlagEffect(tp,103950028)==0
end

--Special Summon cost
function c103950028.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.RegisterFlagEffect(tp,103950028,RESET_PHASE+PHASE_END,0,1)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

--Special Summon filter
function c103950028.spfilter(c,e,tp)
	return c:GetLevel()<=4 and c:IsRace(RACE_DRAGON)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--Special Summon target
function c103950028.sptgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103950028.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

--Special Summon operation
function c103950028.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c103950028.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end