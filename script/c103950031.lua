--Void Shell
function c103950031.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950031,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103950031.target)
	e1:SetOperation(c103950031.operation)
	c:RegisterEffect(e1)
end

--Activate target
function c103950031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--Activate operation
function c103950031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		
		c:SetCardTarget(tc)
		
		--Unaffected by other monster's effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c103950031.value1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		
		--Other monsters are unaffected
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetTarget(c103950031.target2)
		e2:SetValue(c103950031.value2)
		c:RegisterEffect(e2)
		
		--Destroy summoned
		tc:RegisterFlagEffect(103950031,RESET_EVENT+0x1fe0000,0,1)
		
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(103950031,1))
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetLabelObject(tc)
		e6:SetOperation(c103950031.desop)
		c:RegisterEffect(e6)
	end
end

--Unaffected by other monster's effects filter
function c103950031.value1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and
			te:GetHandler():IsLocation(LOCATION_ONFIELD) and
			(e:GetOwner():GetCardTargetCount() == 1) and
			not e:GetOwner():IsHasCardTarget(te:GetHandler())
end

--Other monsters are unaffected target
function c103950031.target2(e,c)
	return not e:GetOwner():IsHasCardTarget(c)
end

--Other monsters are unaffected filter
function c103950031.value2(e,re)
	return re:IsActiveType(TYPE_MONSTER) and
			re:GetHandler():IsLocation(LOCATION_ONFIELD) and
			(e:GetOwner():GetCardTargetCount() == 1) and
			e:GetOwner():IsHasCardTarget(re:GetHandler())
end

--Destruction operation
function c103950031.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(103950031)>0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
