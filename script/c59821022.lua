--The Idol's Duet Combination
function c59821022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c59821022.condition)
	e1:SetCost(c59821022.cost)
	e1:SetTarget(c59821022.target)
	e1:SetOperation(c59821022.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c59821022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c59821022.cfilter(c,tp)
	return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(c59821022.tfilter,tp,LOCATION_MZONE,0,1,c)
end
function c59821022.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821022.cost(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	return true
end
function c59821022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59821022.tfilter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c59821022.cfilter,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c59821022.cfilter,1,1,nil,tp)
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Release(rg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821022.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c59821022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
