--Loli Nao
function c56540010.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56540010,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c56540010.atkcon)
	e1:SetCost(c56540010.atkcost)
	e1:SetTarget(c56540010.atktg)
	e1:SetOperation(c56540010.atkop)
	c:RegisterEffect(e1)
 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56540010,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e2:SetTarget(c56540010.target)
	e2:SetOperation(c56540010.operation)
	c:RegisterEffect(e2)
end
function c56540010.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase>=PHASE_BATTLE_START and phase<=PHASE_BATTLE or (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated())
end
function c56540010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c56540010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c56540010.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56540010.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c56540010.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c56540010.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetOwnerPlayer(tp)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c56540010.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c56540010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c56540010.filter2(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c56540010.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c56540010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		 Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end