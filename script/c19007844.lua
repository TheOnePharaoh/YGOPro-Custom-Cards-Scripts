--Mechquipped Lightning Hound
function c19007844.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c19007844.sumop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30230789,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c19007844.thtg)
	e2:SetOperation(c19007844.thop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCountLimit(1,30230789)
	e3:SetCondition(c19007844.poscon)
	e3:SetTarget(c19007844.tgtg)
	e3:SetOperation(c19007844.tgop)
	c:RegisterEffect(e3)
end
function c19007844.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,30230789)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xda3791))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,30230789,RESET_PHASE+PHASE_END,0,1)
end
function c19007844.thfilter(c)
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsAbleToHand()
end
function c19007844.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19007844.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19007844.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c19007844.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007844.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c19007844.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if tc:IsLocation(LOCATION_GRAVE) then Duel.Recover(tp,500,REASON_EFFECT) end
	end
end
