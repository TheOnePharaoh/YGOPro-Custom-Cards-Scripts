--Vocaloid Fatal Overdrive
function c77662916.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,77662916+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77662916.cost)
	e1:SetTarget(c77662916.target)
	e1:SetOperation(c77662916.activate)
	c:RegisterEffect(e1)
end
function c77662916.costfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c77662916.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c77662916.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c77662916.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c77662916.filter(c,e,tp)
	return c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ) and c:IsRankBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77662916.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c77662916.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c77662916.filter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77662916.filter,tp,LOCATION_EXTRA,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77662916.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
