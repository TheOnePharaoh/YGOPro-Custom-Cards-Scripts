--デッド・シンクロン
function c512000050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000050.target)
	e1:SetOperation(c512000050.operation)
	c:RegisterEffect(e1)
end
function c512000050.filter1(c,e,tp)
	local lv1=c:GetLevel()
	return c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c512000050.filter2,tp,LOCATION_GRAVE,0,1,nil,lv1)
end
function c512000050.filter2(c,lv1)
	local lv2=c:GetLevel()
	return c:IsAbleToRemove() and c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c512000050.filter3,tp,LOCATION_GRAVE,0,1,c,lv1-lv2)
end
function c512000050.filter3(c,lv)
	return c:IsAbleToRemove() and c:GetLevel()==lv and not c:IsType(TYPE_TUNER)
end
function c512000050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c512000050.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512000050.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg1=Duel.SelectMatchingCard(tp,c512000050.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()	
	if not tg1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c512000050.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tg1:GetLevel())	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c512000050.filter3,tp,LOCATION_GRAVE,0,1,1,nil,tg1:GetLevel()-g2:GetFirst():GetLevel())
	g2:Merge(g3)
	if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)>1 and Duel.SpecialSummonStep(tg1,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetOperation(c512000050.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tg1:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
function c512000050.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
