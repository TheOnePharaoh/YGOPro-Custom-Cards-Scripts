--The Legendary Infernal Golem
function c66165075.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c66165075.splimit)
	e2:SetCondition(c66165075.splimcon)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165075,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c66165075.damcon)
	e3:SetTarget(c66165075.damtg)
	e3:SetOperation(c66165075.damop)
	c:RegisterEffect(e3)
	--double tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetValue(c66165075.condition)
	c:RegisterEffect(e4)
end
function c66165075.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsAttribute(ATTRIBUTE_EARTH) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66165075.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c66165075.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(eg:GetFirst():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165075.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c66165075.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c66165075.condition(e,c)
	return c:IsSetCard(0xea010)
end
