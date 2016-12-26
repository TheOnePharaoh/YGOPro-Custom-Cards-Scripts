--Toon Extrio, by Lexxiss666
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
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(scard.sdescon)
	e3:SetOperation(scard.sdesop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(scard.dircon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(scard.attg)
	e5:SetCondition(scard.atcon)
	e5:SetValue(scard.atval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e6:SetCondition(scard.atcon)
	c:RegisterEffect(e6)
	--cannot attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetOperation(scard.atklimit)
	c:RegisterEffect(e7)
	--negate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(s_id,0))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCondition(scard.discon)
	e8:SetCost(scard.discost)
	e8:SetTarget(scard.distg)
	e8:SetOperation(scard.disop)
	c:RegisterEffect(e8)
end
function scard.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	local lv=c:GetLevel()
	if lv<5 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif lv<7 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,nil,1,nil)
	else return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.CheckReleaseGroup(tp,nil,2,nil) end
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local lv=c:GetLevel()
	local tp=c:GetControler()
	if lv<5 then 
	elseif lv<7 then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
		Duel.Release(g,REASON_COST)
	end
end
function scard.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsCode(15259703) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function scard.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.sfilter,1,nil)
end
function scard.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function scard.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function scard.dircon(e)
	return not Duel.IsExistingMatchingCard(scard.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function scard.atcon(e)
	return Duel.IsExistingMatchingCard(scard.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function scard.attg(e,c)
	return not c:IsType(TYPE_TOON)
end
function scard.atval(e,c)
	return c==e:GetHandler()
end
function scard.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function scard.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function scard.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function scard.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function scard.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end