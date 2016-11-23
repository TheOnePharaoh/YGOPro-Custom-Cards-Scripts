--Story of an Unhappy Ending
function c66652247.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,66652247)
	e2:SetCost(c66652247.spcost)
	e2:SetTarget(c66652247.sptg)
	e2:SetOperation(c66652247.spop)
	c:RegisterEffect(e2)
	--sp restrict
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66652247.sumlimit)
	c:RegisterEffect(e3)
end
function c66652247.spfilter(c)
	return c:IsCode(66652230) or c:IsCode(66652231) or c:IsCode(66652232) or c:IsCode(66652262) and c:IsAbleToRemoveAsCost()
end
function c66652247.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652247.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66652247.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66652247.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsType(TYPE_FUSION) and not c:IsImmuneToEffect(e)
end
function c66652247.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x0dac403) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c66652247.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_EXTRA+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c66652247.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c66652247.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c66652247.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c66652247.filter1,tp,LOCATION_EXTRA+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c66652247.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c66652247.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,mg2,mf,chkf)
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
	elseif Duel.IsPlayerCanSpecialSummon(tp) then
		local cg1=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_MZONE,0)
		Duel.ConfirmCards(1-tp,cg1)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_GRAVE,0)
		Duel.ConfirmCards(1-tp,cg2)
		Duel.ShuffleHand(tp)
	end
end
function c66652247.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_FUSION)
end
