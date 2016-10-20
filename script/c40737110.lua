--Dark Magician of Prophecy
--lua script by SGJin
function c40737110.initial_effect(c)
	--Special Summon Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40737110,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40737110.thcon)
	e1:SetTarget(c40737110.thtg)
	e1:SetOperation(c40737110.thop)
	c:RegisterEffect(e1)	
	--Atk and LVL +
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40737110,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c40737110.target)
	e2:SetOperation(c40737110.operation)
	c:RegisterEffect(e2)
end
function c40737110.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and ((re:GetHandler():GetOriginalRace()==RACE_SPELLCASTER and re:GetHandler():IsLevelAbove(4)) 
		or re:GetHandler():IsCode(99789342) or re:GetHandler():IsCode(13604200))
end
function c40737110.filter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c40737110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40737110.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40737110.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40737110.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0
end
function c40737110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40737110.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40737110.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40737110.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c40737110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end
