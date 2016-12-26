--Toon Red Dragon Archfiend
--Created By ALANMAC95, Scripted By TheOnePharaoh
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	if not scard.reg then
	scard.reg=true
	end
--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(scard.atklimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(scard.dircon)
	c:RegisterEffect(e4)
   --destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(scard.condition1)
	e1:SetTarget(scard.target1)
	e1:SetOperation(scard.operation1)
	c:RegisterEffect(e1)
	--destroy2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(s_id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(scard.condition2)
	e2:SetTarget(scard.target2)
	e2:SetOperation(scard.operation2)
	c:RegisterEffect(e2)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(scard.val)
	c:RegisterEffect(e5)
  if not scard.global_check then
		scard.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(s_id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge2:SetOperation(scard.check)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ATTACK_DISABLED)
		ge3:SetOperation(scard.check2)
		Duel.RegisterEffect(ge3,0)
	end
end
function scard.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function scard.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function scard.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(scard.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(scard.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function scard.val(e,c)
	return Duel.GetMatchingGroupCount(scard.filter,0,0x14,LOCATION_GRAVE,nil)*500
end
function scard.filter(c)
	return c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function scard.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(s_id)
	if ct then
		tc:SetFlagEffectLabel(s_id,ct+1)
	else
		tc:RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function scard.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(s_id)
	if ct then
		tc:SetFlagEffectLabel(s_id,ct-1)
	end
end
function scard.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsAttackPos()
end
function scard.filter1(c)
	return not c:IsAttackPos()
end
function scard.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(scard.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function scard.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function scard.filter2(c)
	local ct=c:GetFlagEffectLabel(s_id)
	return (not ct or ct==0)
end
function scard.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function scard.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(scard.filter2,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function scard.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(scard.filter2,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
