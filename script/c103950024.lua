--Duskwing Wyvern
function c103950024.initial_effect(c)

	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--cannot leave field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950024,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c103950024.remlimit)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e2)
	local e3 = e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	local e4 = e1:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e4)
	
	--prevent damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(103950024,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c103950024.pdcon)
	e5:SetOperation(c103950024.pdop)
	c:RegisterEffect(e5)
end

--leave field limit
function c103950024.remlimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

--prevent damage condition
function c103950024.pdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local crp=c:GetReasonPlayer()
	return c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and tp~=crp and crp~=PLAYER_NONE
end

--prevent damage operation
function c103950024.pdop(e,tp,eg,ep,ev,re,r,rp)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(c103950024.pddcon)
	e1:SetOperation(c103950024.pddop)
	Duel.RegisterEffect(e1,tp)
end

--prevent damage battle phase condition
function c103950024.pddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and ep==tp and Duel.GetAttackTarget()==nil
end

--prevent damage battle phase operation
function c103950024.pddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0)
end