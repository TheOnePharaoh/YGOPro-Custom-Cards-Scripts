--Aoi Kiriya
function c59821007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821007.splimit)
	e2:SetCondition(c59821007.splimcon)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821007.tg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821007,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCountLimit(1,59821007)
	e4:SetCondition(c59821007.atcon)
	e4:SetOperation(c59821007.atop)
	c:RegisterEffect(e4)
end
function c59821007.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821007.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821007.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821007.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(59821007)==0
		and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c59821007.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
