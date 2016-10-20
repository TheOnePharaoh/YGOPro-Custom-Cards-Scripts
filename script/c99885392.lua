--B.M.I. Soul Shifting Device
function c99885392.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_DESTROY)
	e1:SetTarget(c99885392.target)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(99885392,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c99885392.rmcost)
	e2:SetTarget(c99885392.rmtg)
	e2:SetOperation(c99885392.rmop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(99885392,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c99885392.spcon)
	e3:SetCost(c99885392.spcost)
	e3:SetTarget(c99885392.sptg)
	e3:SetOperation(c99885392.spop)
	c:RegisterEffect(e3)
end
function c99885392.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=c99885392.rmcost(e,tp,eg,ep,ev,re,r,rp,0) and c99885392.rmtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c99885392.spcon(e,tp,eg,ep,ev,re,r,rp) and c99885392.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c99885392.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local opt=0
		if b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(99885392,0),aux.Stringid(99885392,1))
		elseif b1 then
			opt=Duel.SelectOption(tp,aux.Stringid(99885392,0))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(99885392,1))+1
		end
		if opt==0 then
			e:SetCategory(CATEGORY_REMOVE)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c99885392.rmop)
			c99885392.rmcost(e,tp,eg,ep,ev,re,r,rp,1)
			c99885392.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
			e:SetOperation(c99885392.spop)
			c99885392.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c99885392.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c99885392.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and e:GetHandler():GetFlagEffect(51053997)==0 end
	Duel.PayLPCost(tp,500)
	e:GetHandler():RegisterFlagEffect(51053997,RESET_PHASE+PHASE_END,0,1)
end
function c99885392.rmfil(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToRemove()
end
function c99885392.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99885392.rmfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99885392.rmfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99885392.rmfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99885392.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetCurrentPhase()==PHASE_DRAW then
				e1:SetLabel(Duel.GetTurnCount())
			else
				e1:SetLabel(Duel.GetTurnCount()+2)
			end
		else
			e1:SetLabel(Duel.GetTurnCount()+1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c99885392.retcon)
		e1:SetOperation(c99885392.retop)
		tc:RegisterEffect(e1)
	end
end
function c99885392.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function c99885392.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end
function c99885392.spcfil(c,tp)
	return c:IsPreviousSetCard(0x0dac405) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and not c:IsReason(REASON_BATTLE)
end
function c99885392.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and not eg:IsContains(e:GetHandler()) and eg:IsExists(c99885392.spcfil,1,nil,tp)
end
function c99885392.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(51053997+1)==0 end
	e:GetHandler():RegisterFlagEffect(51053997+1,RESET_PHASE+PHASE_END,0,1)
end
function c99885392.spfil(c,e,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99885392.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c99885392.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99885392.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99885392.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
