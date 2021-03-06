--シンクロパニック
function c512000073.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD)
	e1:SetOperation(c512000073.drop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c512000073.tg)
	e2:SetOperation(c512000073.op)
	c:RegisterEffect(e2)
end
function c512000073.sycfilter(c,code)
	return c:GetCode()==code
end
function c512000073.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	if tg:GetSummonType()==SUMMON_TYPE_SYNCHRO then 
		local code=tg:GetCode()
		local syc=Duel.GetMatchingGroup(c512000073.sycfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,nil,code)
		local tc=syc:GetFirst()
		while tc do
			tc:RegisterFlagEffect(512000073,0,0,1) 	
			tc=syc:GetNext()
		end
	end
end
function c512000073.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(512000073)~=0
end
function c512000073.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c512000073.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c512000073.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c512000073.filter,tp,LOCATION_EXTRA,0,ft1,ft1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(512000074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		g:KeepAlive()
		Duel.SpecialSummonComplete()
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetLabelObject(g)
		e4:SetOperation(c512000073.rmop)
		Duel.RegisterEffect(e4,tp)
	end
end
function c512000073.rmfilter(c)
	return c:GetFlagEffect(512000074)>0
end
function c512000073.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c512000073.rmfilter,nil)
	g:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
