--光子圧力界
function c494476198.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c494476198.target)
	e1:SetOperation(c494476198.operation)
	c:RegisterEffect(e1)
	--trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c494476198.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
  --to hand
  local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c494476198.thcon)
	e4:SetCost(c494476198.thcost)
	e4:SetTarget(c494476198.thtg)
	e4:SetOperation(c494476198.operation)
	e4:SetLabel(1)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c494476198.tgcon)
	e5:SetCost(c494476198.tgcost)
	e5:SetTarget(c494476198.tgtg)
	e5:SetOperation(c494476198.operation)
	e5:SetLabel(2)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_SELF_TOGRAVE)
	e6:SetCondition(c494476198.sdcon)
	c:RegisterEffect(e6)
end

function c494476198.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c494476198.thfilter(chkc) end
		if e:GetLabel()==2 then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c494476198.tgfilter(chkc) end
	end
	if chk==0 then return true end
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_STANDBY
		and Duel.IsExistingTarget(c494476198.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,494476198)==0
		and Duel.SelectYesNo(tp,aux.Stringid(61965407,0)) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c494476198.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.RegisterFlagEffect(tp,494476198,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
	elseif Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
		and Duel.IsExistingTarget(c494476198.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.GetFlagEffect(tp,61965408)==0
		and Duel.SelectYesNo(tp,aux.Stringid(61965407,0)) then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,c61965407.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
		Duel.RegisterFlagEffect(tp,61965408,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(2)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c494476198.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c494476198.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,494476198)==0 end
	Duel.RegisterFlagEffect(tp,494476198,RESET_PHASE+PHASE_END,0,1)
end
function c494476198.thfilter(c)
	return c:IsSetCard(0x600) and c:IsAbleToHand()
end
function c494476198.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c494476198.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c494476198.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c494476198.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c494476198.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c494476198.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,494476198)==0 end
	Duel.RegisterFlagEffect(tp,494476198,RESET_PHASE+PHASE_END,0,1)
end
function c494476198.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x600)
end
function c494476198.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c494476198.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c494476198.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c494476198.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c494476198.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c494476198.sdfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x600)
end
function c494476198.sdcon(e)
	return Duel.IsExistingMatchingCard(c494476198.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c494476198.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x600)
end
function c494476198.operation1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c494476198.filter,1,nil) then
		if (Duel.GetMatchingGroup(c494476198.filter,tp,LOCATION_MZONE,0,nil):GetCount()==0 or Duel.GetMatchingGroup(c494476198.filter,tp,0,LOCATION_MZONE,nil):GetCount()==0)
		 and Duel.SelectYesNo(tp,aux.Stringid(494476198,0)) then
			local td=eg:Filter(c494476198.filter,nil)
			local tc=td:GetFirst()
			local dam=0
			while tc do
				dam=tc:GetLevel()*200
				if Duel.GetMatchingGroup(c494476198.filter,tp,LOCATION_MZONE,0,nil):GetCount()==0 then			
					Duel.Damage(tp,dam,REASON_EFFECT) end
				if Duel.GetMatchingGroup(c494476198.filter,tp,0,LOCATION_MZONE,nil):GetCount()==0 then
					Duel.Damage(1-tp,dam,REASON_EFFECT) end
				tc=td:GetNext()
			end
		end
	end
end

