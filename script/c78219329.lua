--Emergency N.A.NO Supply
function c78219329.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78219329,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c78219329.cost)
	e1:SetTarget(c78219329.target1)
	e1:SetOperation(c78219329.operation1)
	c:RegisterEffect(e1)
end
function c78219329.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1115,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1115,2,REASON_COST)
end
function c78219329.filter1(c)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsType(TYPE_XYZ) and c:IsDestructable()
end
function c78219329.filter2(c)
	return c:IsFaceup() and not c:IsCode(78219329)
end
function c78219329.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c78219329.filter1(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c78219329.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c78219329.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c78219329.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c78219329.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local g=Duel.GetMatchingGroup(c78219329.filter2,tp,LOCATION_ONFIELD,0,nil)
		if g:GetCount()==0 then return end
		for i=1,lv do
			local sg=g:Select(tp,1,1,nil)
			sg:GetFirst():AddCounter(0x1115,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetOperation(c78219329.ctop1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			e3:SetOperation(c78219329.ctop2)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c78219329.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		eg:GetFirst():AddCounter(0x1115,1)
	end
end
function c78219329.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetSummonPlayer()==tp then
			tc:AddCounter(0x1115,1)
		end
		tc=eg:GetNext()
	end
end
