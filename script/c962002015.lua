--Toon Ra the Winged Dragon
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
	--One Turn Kill
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(s_id,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCost(scard.atkcost)
	e5:SetOperation(scard.atkop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(s_id,1))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(scard.descost)
	e6:SetTarget(scard.destg)
	e6:SetOperation(scard.desop)
	c:RegisterEffect(e6)
end
function scard.splimit(e,se,sp,st,spos,tgp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.bfilter(c)
   return c:IsType(TYPE_TOON) and c:IsAbleToRemoveAsCost()
end
function scard.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and Duel.CheckReleaseGroup(tp,nil,3,nil) and Duel.IsExistingMatchingCard(scard.bfilter,tp,LOCATION_HAND,0,3,nil) 
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g1=Duel.SelectReleaseGroup(tp,nil,3,3,nil)
	local g2=Duel.SelectMatchingCard(tp,scard.bfilter,tp,LOCATION_HAND,0,3,3,nil)
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
function scard.bfilter(c)
   return c:IsType(TYPE_TOON) and c:IsAbleToRemoveAsCost()
end
function scard.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function scard.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function scard.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end