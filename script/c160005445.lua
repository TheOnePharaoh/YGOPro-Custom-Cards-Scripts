--Paintress Da Vinca
function c160005445.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160005445.splimit)
	e2:SetCondition(c160005445.splimcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160005445,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c160005445.condition)
	e3:SetTarget(c160005445.target)
	e3:SetOperation(c160005445.operation)
	c:RegisterEffect(e3)
end
function c160005445.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160005445.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160005445.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if not tc:IsType(TYPE_NORMAL) and bc:IsType(TYPE_NORMAL) then tc,bc=bc,tc end
	if tc:IsType(TYPE_NORMAL) and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and not bc:IsType(TYPE_PENDULUM+TYPE_NORMAL) then 
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c160005445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c160005445.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
