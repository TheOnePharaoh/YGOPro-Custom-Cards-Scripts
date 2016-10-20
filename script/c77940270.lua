--Vocaloid Kid Miku Hatsune
function c77940270.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c77940270.target)
	c:RegisterEffect(e2)
end
function c77940270.target(e,c)
	return c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac402) or c:IsSetCard(0x0dac403) or c:IsSetCard(0x0dac404)
end
