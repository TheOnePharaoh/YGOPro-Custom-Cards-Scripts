--myst power
function c89990032.initial_effect(c)
	--limit summon
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c89990032.atktg)
	e2:SetCountLimit(1)
	e2:SetValue(c89990032.valcon)
	c:RegisterEffect(e2)
	--indestruc effect
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c89990032.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c89990032.atktg(e,c)
	return c:IsSetCard(0x22b)
end
function c89990032.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c89990032.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x22b)
end
