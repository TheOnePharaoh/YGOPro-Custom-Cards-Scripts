--Animate Dead
function c77628921.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77628921.cost)
	e1:SetTarget(c77628921.tg)
	e1:SetOperation(c77628921.op)
	c:RegisterEffect(e1)
end
function c77628921.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77628921.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c77628921.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c77628921.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77628921.op(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77628921.filter,tp,LOCATION_GRAVE,0,ft1,ft1,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(77628921,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c77628921.descon)
		e1:SetOperation(c77628921.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c77628921.desfilter(c,fid)
	return c:GetFlagEffectLabel(77628921)==fid
end
function c77628921.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c77628921.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c77628921.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c77628921.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,POS_FACEUP,REASON_EFFECT)
end
