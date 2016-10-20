--B.M.I. Start-Up
function c12385478.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c12385478.target)
	e1:SetOperation(c12385478.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12385478,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12385478)
	e2:SetCondition(c12385478.negcon)
	e2:SetCost(c12385478.negcost)
	e2:SetTarget(c12385478.negtg)
	e2:SetOperation(c12385478.negop)
	c:RegisterEffect(e2)
end
function c12385478.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c12385478.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c12385478.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12385478.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12385478.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12385478.setfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(12385478) and c:IsSSetable()
end
function c12385478.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c12385478.setfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12385478,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end
function c12385478.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c12385478.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12385478.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsRace(RACE_MACHINE) and not c:IsDisabled()
end
function c12385478.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12385478.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12385478.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12385478.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12385478.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsType(TYPE_EFFECT) and not c:IsRace(RACE_MACHINE) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
end
