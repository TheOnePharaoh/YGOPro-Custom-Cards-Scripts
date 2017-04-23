--Aetherian's Unification Ritual
function c59821157.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c59821157.target)
	e1:SetOperation(c59821157.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821157,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c59821157.hncost)
	e2:SetTarget(c59821157.hntg)
	e2:SetOperation(c59821157.hnop)
	c:RegisterEffect(e2)
end
function c59821157.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c59821157.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xa1a2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c59821157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c59821157.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c59821157.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821157.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c59821157.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c59821157.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c59821157.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(59821157,1))
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetTarget(c59821157.drotg)
		e1:SetOperation(c59821157.droop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c59821157.drotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821157.droop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0xa1a2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
function c59821157.cfilter(c)
	return c:IsSetCard(0xa1a2) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_PENDULUM))
		and c:IsAbleToRemoveAsCost()
end
function c59821157.cfilter1(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_FUSION) and mg:IsExists(c59821157.cfilter2,1,nil,mg,ft)
end
function c59821157.cfilter2(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_SYNCHRO) and mg:IsExists(c59821157.cfilter3,1,nil,mg,ft)
end
function c59821157.cfilter3(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ) and mg:IsExists(c59821157.cfilter4,1,nil,ft)
end
function c59821157.cfilter4(c,ft)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and ft>0
end
function c59821157.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c59821157.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and mg:IsExists(c59821157.cfilter1,1,nil,mg,ft+1) end
	local g=Group.FromCards(c)
	ft=ft+1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc1=mg:FilterSelect(tp,c59821157.cfilter1,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc1)
	mg:RemoveCard(rc1)
	if rc1:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc2=mg:FilterSelect(tp,c59821157.cfilter2,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc2)
	mg:RemoveCard(rc2)
	if rc2:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc3=mg:FilterSelect(tp,c59821157.cfilter3,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc3)
	mg:RemoveCard(rc3)
	if rc3:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc4=mg:FilterSelect(tp,c59821157.cfilter4,1,1,nil,ft):GetFirst()
	g:AddCard(rc4)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c59821157.hnfilter(c,e,tp)
	return c:IsCode(59821159) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+400,tp,true,false)
end
function c59821157.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821157.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821157.hnop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821157.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL+400,tp,tp,true,false,POS_FACEUP)
	end
end