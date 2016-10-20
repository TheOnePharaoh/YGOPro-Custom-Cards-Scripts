--Time-Space anomaly
function c103950014.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950014,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103950014.target)
	e1:SetOperation(c103950014.operation)
	c:RegisterEffect(e1)
	
	--Self-Destruct
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c103950014.desop)
	c:RegisterEffect(e2)
	
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--Return
	local e4=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950014,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c103950014.retop)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
end

--Activate target
function c103950014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	if e:GetLabelObject() then
		e:GetLabelObject():DeleteGroup()
		e:SetLabelObject(nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end

--Activate operation
function c103950014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(103950014,RESET_EVENT+0x1fe0000,0,1)
			tc=g:GetNext()
		end
		c:RegisterFlagEffect(103950014,RESET_EVENT+0x17a0000,0,1)
		g:KeepAlive()
		e:SetLabelObject(g)
	end
end

--Self-Destruct condition
function c103950014.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(Card.GetControler,nil,tp):Filter(Card.IsFaceUp,nil):GetCount() > 0
end

--Self-Destruct operation
function c103950014.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

--Return operation
function c103950014.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(103950014)==0 then return end
	
	local g=e:GetLabelObject():GetLabelObject()
	local tc=g:GetFirst()
	local e1 = nil
	while tc do
		if tc:GetFlagEffect(103950014)>0 then
			Duel.ReturnToField(tc)
		end
		tc=g:GetNext()
	end
	g:DeleteGroup()
	e:GetLabelObject():SetLabelObject(nil)
end