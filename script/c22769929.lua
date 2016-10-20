--Dreadnought Mark - Z05 Delta
function c22769929.initial_effect(c)
	c:SetSPSummonOnce(22769929)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c22769929.ovfilter,aux.Stringid(22769929,0),3,c22769929.xyzop)
	c:EnableReviveLimit()
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Trap activate in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22769929.actcon)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--Spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.xyzlimit)
	c:RegisterEffect(e3)
	--Search Trap
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769929,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c22769929.actcon)
	e4:SetCost(c22769929.cost1)
	e4:SetTarget(c22769929.target1)
	e4:SetOperation(c22769929.operation1)
	c:RegisterEffect(e4)
	--Lock
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22769929,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c22769929.actcon)
	e5:SetCost(c22769929.cost2)
	e5:SetTarget(c22769929.target2)
	e5:SetOperation(c22769929.operation2)
	c:RegisterEffect(e5)
	--Spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22769929,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCost(c22769929.cost3)
	e6:SetTarget(c22769929.target3)
	e6:SetOperation(c22769929.operation3)
	c:RegisterEffect(e6)
	--Attach
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22769929,4))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c22769929.actcon)
	e7:SetCost(c22769929.cost4)
	e7:SetTarget(c22769929.target4)
	e7:SetOperation(c22769929.operation4)
	c:RegisterEffect(e7)
end
function c22769929.xyzsumfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGraveAsCost()
end
function c22769929.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsRankBelow(10)
end
function c22769929.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769929.xyzsumfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c22769929.xyzsumfilter,2,2,REASON_COST,nil)
end
function c22769929.conditfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE)
end
function c22769929.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c22769929.conditfilter,1,nil)
end
function c22769929.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22769929.filter1(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c22769929.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and c22769929.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22769929.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22769929.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22769929.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22769929.costfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function c22769929.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769929.costfilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.DiscardHand(tp,c22769929.costfilter,3,3,REASON_COST+REASON_DISCARD)
end
function c22769929.filter2(c)
	return c:IsAbleToRemove()
end
function c22769929.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22769929.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22769929.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c22769929.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c22769929.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1 then
		local seq=tc1:GetSequence()
		if tc1:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc1:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc1:IsRelateToEffect(e) then
		Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c22769929.discon)
		e1:SetOperation(c22769929.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc1)
		e2:SetCountLimit(1)
		e2:SetCondition(c22769929.recon)
		e2:SetOperation(c22769929.retop)
		Duel.RegisterEffect(e2,tp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c22769929.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		local seq=tc2:GetSequence()
		if tc2:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc2:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc2:IsRelateToEffect(e) then
		Duel.Remove(tc2,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc2)
		e1:SetCondition(c22769929.discon)
		e1:SetOperation(c22769929.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc2)
		e2:SetCountLimit(1)
		e2:SetCondition(c22769929.recon)
		e2:SetOperation(c22769929.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectTarget(tp,c22769929.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc3=g3:GetFirst()
	if tc3 then
		local seq=tc3:GetSequence()
		if tc3:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc3:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc3:IsRelateToEffect(e) then
		Duel.Remove(tc3,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc3)
		e1:SetCondition(c22769929.discon)
		e1:SetOperation(c22769929.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc3)
		e2:SetCountLimit(1)
		e2:SetCondition(c22769929.recon)
		e2:SetOperation(c22769929.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
end
function c22769929.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22769929.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22769929.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c22769929.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
function c22769929.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769929.filter3(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769929.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22769929.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22769929.filter3,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22769929.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22769929.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22769929.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c22769929.filter4(c,tp)
	return not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c22769929.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22769929.filter4(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c22769929.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22769929.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c22769929.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end