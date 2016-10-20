--Vocaloid Haku Yowane/Modified
function c13739085.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c13739085.operation)
	c:RegisterEffect(e2)
end
function c13739085.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and a:IsRace(RACE_MACHINE) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and d:IsRace(RACE_MACHINE) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e2)
end
