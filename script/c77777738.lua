--Necromantic Sorcerer
function c77777738.initial_effect(c)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777738,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c77777738.thtg)
	e1:SetOperation(c77777738.thop)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77777738.condition)
	e2:SetOperation(c77777738.operation)
	c:RegisterEffect(e2)
end

function c77777738.thfilter(c)
	return c:IsSetCard(0x1c8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77777738.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c77777738.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777738.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77777738.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77777738.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c77777738.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c77777738.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if rc:IsSetCard(0x1c8)then
	while rc do
		if rc:GetFlagEffect(77777738)==0 then
			--direct attack
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(77777738,1))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetCondition(c77777738.dircon)
			rc:RegisterEffect(e1,true)
			--search
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(77777738,2))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2:SetType(EFFECT_TYPE_IGNITION)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCondition(c77777738.addcon)
			e2:SetTarget(c77777738.shtg)
			e2:SetOperation(c77777738.shop)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(77777738,RESET_EVENT+0x1fe0000,0,1)
		end
		rc=eg:GetNext()
	end
	end
end

function c77777738.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1c8)and c:GetType()==0x81
end
function c77777738.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77777738.cfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c77777738.dircon(e,tp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==5
end

function c77777738.shfilter(c)
	return c:IsSetCard(0x1c8) and c:GetType()==0x20002 and c:IsAbleToHand()
end
function c77777738.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777738.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777738.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end