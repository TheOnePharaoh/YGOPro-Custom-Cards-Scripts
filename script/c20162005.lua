--Lizardfolk Resting Place
function c20162005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20162005.cost)
	e1:SetTarget(c20162005.target)
	e1:SetOperation(c20162005.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c20162005.reptg)
	e2:SetValue(c20162005.repval)
	c:RegisterEffect(e2)
end
function c20162005.cfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToDeckAsCost()
end
function c20162005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20162005.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c20162005.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20162005.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20162005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c20162005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c20162005.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20162005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,ft1,ft1,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(20162005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
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
		e1:SetCondition(c20162005.tdcon)
		e1:SetOperation(c20162005.tdsop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20162005.tdfilter(c,fid)
	return c:GetFlagEffectLabel(20162005)==fid
end
function c20162005.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c20162005.tdfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c20162005.tdsop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c20162005.tdfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
end
function c20162005.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsRace(RACE_REPTILE)
end
function c20162005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c20162005.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(20162005,0)) then
		local g=eg:Filter(c20162005.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c20162005.repval(e,c)
	return c==e:GetLabelObject()
end
