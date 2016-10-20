--Colossal Warrior - Wall
function c78219308.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(c78219308.reptg)
	e1:SetValue(c78219308.repval)
	e1:SetOperation(c78219308.repop)
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c78219308.repcon)
	e2:SetOperation(c78219308.repop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219308,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c78219308.stg)
	e3:SetOperation(c78219308.sop)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c78219308.limcon)
	e4:SetOperation(c78219308.limop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAIN_END)
	e6:SetOperation(c78219308.limop2)
	c:RegisterEffect(e6)
end
function c78219308.refilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
		and c:IsSetCard(0x7ad30) and not c:IsReason(REASON_REPLACE)
end
function c78219308.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c78219308.refilter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(78219308,0))
end
function c78219308.repval(e,c)
	return c78219308.filter(c,e:GetHandlerPlayer())
end
function c78219308.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c78219308.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219308.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219308,e,0,tp,0,0)
end
function c78219308.sfilter(c)
	return c:IsCode(78219322) and c:IsAbleToHand()
end
function c78219308.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219308.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c78219308.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78219308.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c78219308.limfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c78219308.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78219308.limfilter,1,nil,tp)
end
function c78219308.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c78219308.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(78219308,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c78219308.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(78219308)~=0 then
		Duel.SetChainLimitTillChainEnd(c78219308.chainlm)
	end
	e:GetHandler():ResetFlagEffect(78219308)
end
function c78219308.chainlm(e,rp,tp)
	return tp==rp
end