--オーバー・チューン
function c512000072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000072.target)
	e1:SetOperation(c512000072.operation)
	c:RegisterEffect(e1)
end
function c512000072.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c512000072.filter,tp,LOCATION_HAND,0,1,nil,lv,e,tp)
end
function c512000072.filter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c512000072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c512000072.cfilter,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c512000072.cfilter,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c512000072.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c512000072.filter,tp,LOCATION_HAND,0,1,1,nil,e:GetLabel(),e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
