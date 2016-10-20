--Vocaloid Megurine Luka
function c46035561.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46035561,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c46035561.reccon)
	e1:SetTarget(c46035561.rectg)
	e1:SetOperation(c46035561.recop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
end
function c46035561.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c46035561.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c46035561.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c46035561.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c46035561.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c46035561.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
