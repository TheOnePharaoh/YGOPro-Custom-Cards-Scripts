--Choir - Song of Mourning and Lamentation
function c84435260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c84435260.target1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84435260,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,84435260)
	e2:SetCondition(c84435260.descon)
	e2:SetCost(c84435260.descost)
	e2:SetTarget(c84435260.destg)
	e2:SetOperation(c84435260.desop)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84435260,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,84435260)
	e3:SetCondition(c84435260.atkcon)
	e3:SetCost(c84435260.atkcost)
	e3:SetOperation(c84435260.atkop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,84435260)
	e4:SetCondition(c84435260.setcon)
	e4:SetTarget(c84435260.settg)
	e4:SetOperation(c84435260.setop)
	c:RegisterEffect(e4)
end
function c84435260.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.CheckEvent(EVENT_TO_HAND) and c84435260.descon(e,tp,eg,ep,ev,re,r,rp) and c84435260.descost(e,tp,eg,ep,ev,re,r,rp,0) and c84435260.destg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c84435260.atkcon(e,tp,eg,ep,ev,re,r,rp) and c84435260.atkcost(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(84435260,0),aux.Stringid(84435260,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(84435260,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(84435260,1))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_DESTROY)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			c84435260.descost(e,tp,eg,ep,ev,re,r,rp,1)
			c84435260.destg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c84435260.desop)
		else
			e:SetCategory(0)
			e:SetProperty(0)
			c84435260.atkcost(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c84435260.atkop)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c84435260.descfil(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x0dac405)
end
function c84435260.descon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and eg:IsExists(c84435260.descfil,1,nil)
end
function c84435260.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,84435260)==0 end
	Duel.RegisterFlagEffect(tp,84435260,RESET_PHASE+PHASE_END,0,1)
end
function c84435260.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c84435260.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c84435260.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c84435260.atkcfil(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsAbleToRemoveAsCost()
end
function c84435260.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,84435260+1)==0 and Duel.IsExistingMatchingCard(c84435260.atkcfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.RegisterFlagEffect(tp,84435260+1,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c84435260.atkcfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c84435260.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
function c84435260.setfil(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
function c84435260.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c84435260.setfil,1,nil,tp)
end
function c84435260.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c84435260.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
