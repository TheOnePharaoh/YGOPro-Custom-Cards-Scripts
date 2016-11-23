--Black Cloak
function c59821138.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821138)
	e1:SetCondition(c59821138.condition)
	e1:SetOperation(c59821138.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c59821138.handcon)
	c:RegisterEffect(e2)
end
function c59821138.cfil(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821138.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c59821138.cfil,tp,LOCATION_MZONE,0,1,nil)
end
function c59821138.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c59821138.disoperation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  if (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
    Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
  end
end
function c59821138.disoperation(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and rp~=tp then
		Duel.NegateEffect(ev)
	end
end
function c59821138.hfil(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ) and c:IsRankAbove(5)
end
function c59821138.handcon(e)
	local tp=e:GetHandlerPlayer()
	return c59821138.condition(e,tp) and Duel.IsExistingMatchingCard(c59821138.hfil,tp,LOCATION_MZONE,0,1,nil)
end