--−ゼロ・リバース
function c512000045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c512000045.target)
	e1:SetOperation(c512000045.activate)
	c:RegisterEffect(e1)
end
function c512000045.filter(c,id,e,tp)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c512000045.filter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c512000045.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c512000045.filter,tp,LOCATION_GRAVE,0,1,1,nil,Duel.GetTurnCount(),e,tp):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
