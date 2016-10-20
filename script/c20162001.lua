--Lizardfolk - Assault Squad
function c20162001.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20162001,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c20162001.atkcon)
	e1:SetCost(c20162001.atkcost)
	e1:SetTarget(c20162001.atktg)
	e1:SetOperation(c20162001.atkop)
	c:RegisterEffect(e1)
end
function c20162001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c20162001.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c20162001.atkfil(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end
function c20162001.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20162001.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20162001.atkfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c20162001.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20162001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20162001,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c20162001.aclimit)
	e2:SetCondition(c20162001.actcon)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20162001,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetValue(LOCATION_DECKBOT)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
end
function c20162001.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c20162001.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
