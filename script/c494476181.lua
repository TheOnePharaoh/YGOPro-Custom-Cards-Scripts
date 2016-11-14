function c494476181.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c494476181.sumlimit)
	c:RegisterEffect(e2)
  --INDES
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetCondition(c494476181.nmcon)
  e3:SetValue(c494476181.indval)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  c:RegisterEffect(e4)
end

function c494476181.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsAttackAbove(0)
end

function c494476181.nmcon(e)
return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>0
end

function c494476181.indval(e,re,rp)
return re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end

