--Toon Obelisk the Tormentor
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
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(scard.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(scard.spcon)
	e2:SetOperation(scard.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(scard.atop)
	c:RegisterEffect(e4)
end
function scard.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.bfilter(c)
   return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x62) and c:IsAbleToRemoveAsCost()
end
function scard.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and Duel.CheckReleaseGroup(tp,nil,3,nil) and Duel.IsExistingMatchingCard(scard.bfilter,tp,LOCATION_GRAVE,0,3,nil) 
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g1=Duel.SelectReleaseGroup(tp,nil,3,3,nil)
	local g2=Duel.SelectMatchingCard(tp,scard.bfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Release(g1,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function scard.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(scard.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function scard.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end