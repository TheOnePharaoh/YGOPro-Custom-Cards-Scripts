--Secret Art of Darkness Step 5 - Truth
function c66652262.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66652262.target)
	e1:SetOperation(c66652262.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66652262,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,66652262)
	e2:SetCondition(c66652262.spcon)
	e2:SetCost(c66652262.spcost)
	e2:SetTarget(c66652262.sptg)
	e2:SetOperation(c66652262.spop)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x0dac403)
	c:RegisterEffect(e3)
end
function c66652262.confilter(c)
	return c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac402)
end
function c66652262.mfilter0(c)
	return c:IsType(TYPE_MONSTER) and c66652262.confilter(c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c66652262.mfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c66652262.mfilter2(c,e)
	return c:IsType(TYPE_MONSTER) and c66652262.confilter(c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c66652262.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c66652262.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x0dac403) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c66652262.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND,0,nil)
		local res=Duel.IsExistingMatchingCard(c66652262.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(c66652262.mfilter0,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(c66652262.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c66652262.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66652262.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c66652262.mfilter1,tp,LOCATION_HAND,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c66652262.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(c66652262.mfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e)
	mg2:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(c66652262.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	sg1:Merge(sg2)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c66652262.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x0dac403) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				tc:SetMaterial(mat1)
				local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_EXTRA)
				mat1:Sub(mat2)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c66652262.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c66652262.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66652262.spfilter(c,e,tp,turn)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetTurnID()==turn
end
function c66652262.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turn=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66652262.spfilter(chkc,e,tp,turn) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c66652262.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,turn) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c66652262.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,turn)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c66652262.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
