--Paintress Baconia
function c160008746.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160008746.splimit)
	e2:SetCondition(c160008746.splimcon)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c160008746.tgtg)
	e3:SetValue(c160008746.tgval)
	c:RegisterEffect(e3)
end
function c160008746.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160008746.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160008746.tgtg(e,c)
	return c:IsFaceup() and (c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL))
end
function c160008746.tgval(e,re,rp)
	return re:GetHandler():IsType(TYPE_MONSTER)
end
