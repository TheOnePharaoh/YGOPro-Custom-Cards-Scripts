--超融合
function c512000015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c512000015.cost)
	e1:SetTarget(c512000015.target)
	e1:SetOperation(c512000015.activate)
	c:RegisterEffect(e1)
	if not c512000015.global_check then
		c512000015.global_check=true
		c512000015[0]=true
		c512000015[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c512000015.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_MSET)
		ge2:SetOperation(c512000015.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_SSET)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge1:Clone()
		ge5:SetCode(EVENT_CHANGE_POS)
		ge5:SetOperation(c512000015.checkop3)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_ADJUST)
		ge6:SetCountLimit(1)
		ge6:SetOperation(c512000015.clear)
		Duel.RegisterEffect(ge6,0)
	end
end
function c512000015.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_TRAP) then
		c512000015[rp]=false
	end
end
function c512000015.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsFacedown,1,nil) then
		c512000015[ep]=false
	end
end
function c512000015.sfilter(c)
	return c:IsFacedown() and c:IsPreviousPosition(POS_FACEUP)
end
function c512000015.checkop3(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c512000015.sfilter,1,nil) then
		c512000015[ep]=false
	end
end
function c512000015.clear(e,tp,eg,ep,ev,re,r,rp)
	c512000015[0]=true
	c512000015[1]=true
end
function c512000015.filter0(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial()
end
function c512000015.filter1(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c512000015.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c512000015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c512000015[tp] and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTarget(c512000015.sumlimit)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,0)
	e5:SetValue(c512000015.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c512000015.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
function c512000015.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c512000015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c512000015.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		local res=Duel.IsExistingMatchingCard(c512000015.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c512000015.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c512000015.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c512000015.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local sg1=Duel.GetMatchingGroup(c512000015.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c512000015.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
