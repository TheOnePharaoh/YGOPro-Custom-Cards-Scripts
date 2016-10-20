--Secret Art of Darkness Step 4 - The Seed of Evil
function c66652252.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66652252+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c66652252.cost)
	e1:SetTarget(c66652252.target)
	e1:SetOperation(c66652252.activate)
	c:RegisterEffect(e1)
end
function c66652252.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac403) and c:IsType(TYPE_FUSION)
end
function c66652252.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c66652252.costfilter,3,nil) end
	local g=Duel.SelectReleaseGroup(tp,c66652252.costfilter,3,3,nil)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_SELF_TURN+RESET_PHASE+RESET_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPSUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c66652252.filter(c,e,tp)
	return c:IsCode(66652259) and c:IsCanBeSpecialSummoned(e,563,tp,true,false)
end
function c66652252.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66652252.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66652252.dfilter(c)
	return not c:IsCode(66652259) or not c:IsCode(66652241) or not c:IsCode(66652246) or not c:IsCode(66652245)
end
function c66652252.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ct=0
	if ft==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c66652252.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		ct=Duel.SpecialSummon(g,563,tp,tp,true,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c66652252.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g1:GetCount()>0 and Duel.SpecialSummonStep(g1:GetFirst(),563,tp,tp,true,false,POS_FACEUP) then ct=ct+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c66652252.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g2:GetCount()>0 and Duel.SpecialSummonStep(g2:GetFirst(),563,tp,tp,true,false,POS_FACEUP) then ct=ct+1 end
		Duel.SpecialSummonComplete()
	end
	if ct>0 then
		local dg=Duel.GetMatchingGroup(c66652252.dfilter,tp,LOCATION_MZONE,0,nil)
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
