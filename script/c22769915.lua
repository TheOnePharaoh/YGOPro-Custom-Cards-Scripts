--Dreadnought Mark - Z03 Excelsus
function c22769915.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),10,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetCondition(c22769915.dscon)
	e3:SetTarget(c22769915.distg)
	c:RegisterEffect(e3)
	--copy effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769915,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0x3c0)
	e4:SetCountLimit(1)
	e4:SetCondition(c22769915.condition)
	e4:SetCost(c22769915.cost)
	e4:SetTarget(c22769915.target)
	e4:SetOperation(c22769915.operation)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22769915,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1)
	e5:SetCost(c22769915.cost)
	e5:SetTarget(c22769915.target2)
	e5:SetOperation(c22769915.operation)
	c:RegisterEffect(e5)
end
function c22769915.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22769915.distg(e,c)
	return c:IsType(TYPE_COUNTER)
end
function c22769915.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING)
end
function c22769915.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():GetFlagEffect(22769915)==0 end
	e:GetHandler():RegisterFlagEffect(22769915,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22769915.filter1(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToDeckAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c22769915.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c22769915.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c22769915.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c22769915.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c22769915.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_COUNTER) and c:IsAbleToDeckAsCost() then
		if c:CheckActivateEffect(false,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function c22769915.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c22769915.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c22769915.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c22769915.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
