--Odds and End - Song of Vague and Sadness
function c97341618.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c97341618.condition)
	e1:SetTarget(c97341618.target)
	e1:SetOperation(c97341618.activate)
	c:RegisterEffect(e1)
	--Change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97341618,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,97341618)
	e2:SetCost(c97341618.lvlcost)
	e2:SetTarget(c97341618.lvltg)
	e2:SetOperation(c97341618.lvlop)
	c:RegisterEffect(e2)
end
function c97341618.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c97341618.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c97341618.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsExistingMatchingCard(c97341618.filter,tp,LOCATION_GRAVE,0,ct,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97341618.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c97341618.filter,tp,LOCATION_GRAVE,0,ct,ct,nil,e,tp)
	if g:GetCount()==ct then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c97341618.costfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c97341618.lvlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c97341618.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c97341618.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetRank())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c97341618.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405)
end
function c97341618.lvltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97341618.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c97341618.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c97341618.tgfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c97341618.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c97341618.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_MACHINE)
end
