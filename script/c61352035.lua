--Vocaloid Len Kagamine
function c61352035.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61352035,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c61352035.atcon)
	e1:SetOperation(c61352035.atop)
	c:RegisterEffect(e1)
end
function c61352035.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c61352035.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end