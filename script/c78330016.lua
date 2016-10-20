--Thanatosis
function c78330016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c78330016.target)
	e1:SetOperation(c78330016.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(78330016,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c78330016.thcost)
	e2:SetTarget(c78330016.thtg)
	e2:SetOperation(c78330016.thop)
	c:RegisterEffect(e2)
end
function c78330016.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xac9812)
end
function c78330016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c78330016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78330016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c78330016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(78330016,0),aux.Stringid(78330016,1))
	e:SetLabel(opt)
end
function c78330016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		if e:GetLabel()==0 then
			e2:SetValue(c78330016.efilter1)
		else 
			e2:SetValue(c78330016.efilter2) 
		end
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c78330016.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c78330016.efilter2(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c78330016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c78330016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c78330016.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
