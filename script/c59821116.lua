--Hikami Sumire 
function c59821116.initial_effect(c)
	aux.EnableDualAttribute(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821116.splimit)
	e2:SetCondition(c59821116.splimcon)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
	--code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(59821006)
	c:RegisterEffect(e4)
	--skip main phase
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821116,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c59821116.skipcon)
	e5:SetOperation(c59821116.skipop)
	c:RegisterEffect(e5)
	--Tuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(aux.IsDualState)
	e6:SetValue(TYPE_TUNER)
	c:RegisterEffect(e6)
end
function c59821116.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821116.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821116.skipcon(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsDualState(e) then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c59821116.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
