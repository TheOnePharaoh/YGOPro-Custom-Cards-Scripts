--Red Dragon Hatchling
function c999904.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999904,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,999904)
	e1:SetCondition(c999904.spcon)
	e1:SetCost(c999904.spcost)
	e1:SetTarget(c999904.sptg)
	e1:SetOperation(c999904.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(999904,ACTIVITY_SPSUMMON,c999904.counterfilter)
end
function c999904.counterfilter(c)
	return c:IsSetCard(0x1045)
end
function c999904.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x1045)
end
function c999904.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(999904,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c999904.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c999904.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1045)
end
function c999904.filter(c,e,tp)
	return c:IsSetCard(0x1045) and not c:IsCode(999904) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999904.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999904.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c999904.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c999904.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
