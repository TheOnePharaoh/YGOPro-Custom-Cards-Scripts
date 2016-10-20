--Blood of the May-Raias
function c87002911.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c87002911.cost)
	e1:SetTarget(c87002911.tg)
	e1:SetOperation(c87002911.op)
	c:RegisterEffect(e1)
end
function c87002911.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe291ca) and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
end
function c87002911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c87002911.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c87002911.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c87002911.op(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002911.filter,tp,LOCATION_GRAVE,0,ft1,ft1,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,200,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(87002911,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
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
		e1:SetCondition(c87002911.descon)
		e1:SetOperation(c87002911.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c87002911.desfilter(c,fid)
	return c:GetFlagEffectLabel(87002911)==fid
end
function c87002911.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c87002911.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c87002911.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c87002911.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,POS_FACEUP,REASON_EFFECT)
end
