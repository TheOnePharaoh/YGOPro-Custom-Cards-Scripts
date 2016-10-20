--Acme Torture Stamper
function c160008957.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetDescription(aux.Stringid(160008957,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c160008957.ctcon)
	e2:SetOperation(c160008957.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--fusion
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(160008957,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetTarget(c160008957.target)
	e5:SetOperation(c160008957.operation)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(160008957,2))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCondition(c160008957.damcon)
	e6:SetTarget(c160008957.damtg)
	e6:SetOperation(c160008957.damop)
	c:RegisterEffect(e6)
end
function c160008957.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsSetCard(0xc81)
end
function c160008957.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x10cc,1)
end
function c160008957.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x10cc)
	e:SetLabel(ct)
	return ct>0 and c:IsReason(REASON_DESTROY)
end
function c160008957.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel()*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,-tp,e:GetLabel()*100)
end
function c160008957.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c160008957.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c160008957.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc81) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x16,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c160008957.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c160008957.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c160008957.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c160008957.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c160008957.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c160008957.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c160008957.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c160008957.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+0x16,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
