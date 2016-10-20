--Mail Box of Doom
function c160006300.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160006300,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c160006300.cost)
	e1:SetTarget(c160006300.target)
	e1:SetOperation(c160006300.operation)
	c:RegisterEffect(e1)
		--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c160006300.efcon)
	e2:SetOperation(c160006300.efop)
	c:RegisterEffect(e2)
end
function c160006300.cfilter(c)
	return c:IsSetCard(0xc81) and c:IsType(TYPE_MONSTER) and  c:GetCode()~=160006300 and c:IsDiscardable()
end
function c160006300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c160006300.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.DiscardHand(tp,c160006300.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c160006300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160006300.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160006300.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160006300.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c160006300.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c160006300.ffilter(c)
	return not c:IsSetCard(0xc81)
end
function c160006300.efcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return not ec:GetMaterial():IsExists(c160006300.ffilter,1,nil) and r==REASON_XYZ
end
function c160006300.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,160006300)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(160006300,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c160006300.atkcon)
	e1:SetTarget(c160006300.atktg)
	e1:SetOperation(c160006300.atkop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(rc)
	e3:SetDescription(aux.Stringid(160006300,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c160006300.discon)
	e3:SetTarget(c160006300.distg)
	e3:SetOperation(c160006300.disop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3,true)
	end
end
function c160006300.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c160006300.atkfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c160006300.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160006300.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160006300.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160006300.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c160006300.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c160006300.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c160006300.cofilter(c)
	return c:IsFaceup() and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c160006300.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c160006300.cofilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160006300.cofilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160006300.cofilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c160006300.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end