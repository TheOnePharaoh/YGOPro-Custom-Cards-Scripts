--Serpent Blade
function c44559805.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c44559805.target)
	e1:SetOperation(c44559805.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c44559805.eqlimit)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44559805,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,44559805)
	e3:SetTarget(c44559805.thtg)
	e3:SetOperation(c44559805.thop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559805,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c44559805.retcon)
	e4:SetTarget(c44559805.rettg)
	e4:SetOperation(c44559805.retop)
	c:RegisterEffect(e4)
end
function c44559805.eqlimit(e,c)
	return not c:IsType(TYPE_FUSION)
end
function c44559805.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_FUSION)
end
function c44559805.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44559805.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44559805.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c44559805.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff-g:GetFirst():GetRace())
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c44559805.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local rc=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(rc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		c:SetHint(CHINT_RACE,rc)
	end
end
function c44559805.seafilter(c)
	return c:IsCode(44559804) or c:IsCode(24094653) or c:IsCode(48130397) or c:IsCode(160007731) or c:IsCode(74335036) or c:IsCode(27847700) and c:IsAbleToHand()
end
function c44559805.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559805.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c44559805.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44559805.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c44559805.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_FUSION)
end
function c44559805.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c44559805.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end