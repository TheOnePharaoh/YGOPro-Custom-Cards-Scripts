--Dark Future Fusion
function c888000018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c888000018.target)
	e1:SetOperation(c888000018.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c888000018.desop)
	c:RegisterEffect(e2)
	--Destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c888000018.descon2)
	e3:SetOperation(c888000018.desop2)
	c:RegisterEffect(e3)
end
function c888000018.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c888000018.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x10,PLAYER_NONE,false,false)
		and c:CheckFusionMaterial(m) and c:IsSetCard(0x102)
end
function c888000018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c888000018.filter1,tp,LOCATION_DECK,0,nil,e)
		return Duel.IsExistingMatchingCard(c888000018.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	e:GetHandler():SetTurnCounter(0)
end
function c888000018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c888000018.filter1,tp,LOCATION_DECK,0,nil,e)
	local sg=Duel.GetMatchingGroup(c888000018.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
		local tc=fg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=fg:GetNext()
		end
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetRange(LOCATION_SZONE)
		e1:SetOperation(c888000018.proc)
		e1:SetLabel(code)
		e1:SetLabelObject(e)
		c:RegisterEffect(e1)
	end
end
function c888000018.procfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x10,tp,false,false)
end
function c888000018.proc(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		local code=e:GetLabel()
		local tc=Duel.GetFirstMatchingCard(c888000018.procfilter,tp,LOCATION_EXTRA,0,nil,code,e,tp)
		if not tc then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			tc:CompleteProcedure()
		else
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+0x10,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			c:SetCardTarget(tc)
		end
	end
end
function c888000018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c888000018.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c888000018.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
