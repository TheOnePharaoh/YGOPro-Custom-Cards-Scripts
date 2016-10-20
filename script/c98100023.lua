--Regret Message - Song of Northen Horizon
function c98100023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c98100023.target1)
	e1:SetOperation(c98100023.operation)
	c:RegisterEffect(e1)
	--to Grave
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c98100023.target2)
	e2:SetOperation(c98100023.operation)
	c:RegisterEffect(e2)
	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c98100023.target)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c98100023.mtop)
	c:RegisterEffect(e5)
end
function c98100023.rfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function c98100023.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c98100023.rfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c98100023.rfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98100023,0)) then
	local cg=Duel.SelectTarget(tp,c98100023.rfilter,tp,LOCATION_HAND,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(98100023,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else e:SetProperty(0) end
end
function c98100023.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c98100023.rfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(98100023)==0
		and Duel.IsExistingTarget(c98100023.rfilter,tp,LOCATION_HAND,0,1,nil) end
	local cg=Duel.SelectTarget(tp,c98100023.rfilter,tp,LOCATION_HAND,0,1,1,nil)
	if cg:GetCount()==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(98100023,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c98100023.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c98100023.target(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c98100023.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>700 and Duel.SelectYesNo(tp,aux.Stringid(98100023,1)) then
		Duel.PayLPCost(tp,700)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
