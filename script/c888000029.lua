--Bloodline Ceremony
function c888000029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c888000029.target)
	e1:SetOperation(c888000029.activate)
	c:RegisterEffect(e1)
end
function c888000029.filter123(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c888000029.filter456(c,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsAbleToRemove()
end
function c888000029.filter(c,e,tp,m)
	if not c:IsSetCard(0x888) or not c:IsType(TYPE_RITUAL)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local mg=m:Clone()
	mg:RemoveCard(c)
	if c:GetLevel()<=3 then
		return Duel.IsExistingMatchingCard(c888000029.filter123,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK,3,c)
	end
	if c:GetLevel()>=4 and c:GetLevel()<=6 then
		return Duel.IsExistingMatchingCard(c888000029.filter456,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetLevel())
	else
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	end
end
function c888000029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c888000029.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c888000029.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c888000029.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		if tc:GetLevel()<=3 then
			local mg2=Duel.GetMatchingGroup(c888000029.filter123,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK,nil):RandomSelect(tp,3)
			tc:SetMaterial(mg2)
			Duel.SendtoGrave(mg2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if tc:GetLevel()>=4 and tc:GetLevel()<=6 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local mat=Duel.SelectMatchingCard(tp,c888000029.filter456,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,tc:GetLevel())
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if tc:GetLevel()>=7 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
