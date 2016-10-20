--High Mystical Protection
function c89990008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c89990008.condition)
	e1:SetCost(c89990008.cost)
	e1:SetTarget(c89990008.target)
	e1:SetOperation(c89990008.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c89990008.batcon)
	e2:SetCost(c89990008.batcost)
	e2:SetOperation(c89990008.batop)
	c:RegisterEffect(e2)
end
function c89990008.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c89990008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c89990008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c89990008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and tc:IsRelateToEffect(e) and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.NegateAttack()
	end
end
function c89990008.batcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c89990008.batcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c89990008.batop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
