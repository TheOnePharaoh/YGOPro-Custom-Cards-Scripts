--Sword Art Style - Dual Wield
function c20912261.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20912261.target)
	e1:SetOperation(c20912261.activate)
	c:RegisterEffect(e1)
end
function c20912261.filter(c,e,tp)
	return c:IsSetCard(0xd0a2) and c:GetLevel()==4 and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912261.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c20912261.mfilter1(c,exg)
	return exg:IsExists(c20912261.mfilter2,1,nil,c)
end
function c20912261.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c20912261.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c20912261.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c20912261.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c20912261.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c20912261.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c20912261.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c20912261.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c20912261.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912261.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c20912261.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c20912261.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
