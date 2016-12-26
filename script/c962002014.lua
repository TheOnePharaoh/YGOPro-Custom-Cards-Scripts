--Toon Slifer the Sky Dragon
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
	--atk/def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(scard.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)
    --atkdown
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(10000020,1))
    e8:SetCategory(CATEGORY_ATKCHANGE)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetCondition(scard.atkcon)
    e8:SetTarget(scard.atktg)
    e8:SetOperation(scard.atkop)
    c:RegisterEffect(e8)
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
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and Duel.CheckReleaseGroup(tp,nil,3,nil) and Duel.IsExistingMatchingCard(scard.bfilter,tp,LOCATION_DECK,0,3,nil) 
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g1=Duel.SelectReleaseGroup(tp,nil,3,3,nil)
	local g2=Duel.SelectMatchingCard(tp,scard.bfilter,tp,LOCATION_DECK,0,3,3,nil)
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
function scard.adval(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_TOON)*1000
end
function scard.atkfilter(c,e,tp)
    return c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function scard.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(scard.atkfilter,1,nil,nil,1-tp)
end
function scard.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
    Duel.SetTargetCard(eg)
end
function scard.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(scard.atkfilter,nil,e,1-tp)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end