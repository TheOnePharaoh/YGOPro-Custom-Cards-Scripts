--Tessalia the Mystical Sorceress
function c89990027.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--battle effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89990028,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c89990027.target)
	e2:SetOperation(c89990027.operation)
	c:RegisterEffect(e2)
end
function c89990027.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c89990027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c89990027.filter(chkc) end
	local op=2
	if chk==0 then return Duel.IsExistingTarget(c89990027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
		or Duel.CheckReleaseGroup(tp,nil,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(89990027,0))
	if Duel.IsExistingTarget(c89990027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
		and Duel.CheckReleaseGroup(tp,nil,1,c) then
		op=Duel.SelectOption(tp,aux.Stringid(89990027,1),aux.Stringid(89990027,2))
	elseif Duel.IsExistingTarget(c89990027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.SelectOption(tp,aux.Stringid(89990027,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(89990027,2))
		op=1
	end
	if op==0 then
		Duel.NegateAttack(e:GetHandler())
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c89990027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,c)
		Duel.Release(g,REASON_COST)
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(0)
	end
	Duel.SetTargetParam(op)
end
function c89990027.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif op==1 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(c:GetBaseAttack()*2)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
