--Toon-Raptor Rise Falcon
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
   --atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(s_id,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCost(scard.cost)
	e5:SetTarget(scard.target)
	e5:SetOperation(scard.operation)
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

function scard.costfilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToGraveAsCost()
end
function scard.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,scard.costfilter,1,1,REASON_COST)
end
function scard.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and scard.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,scard.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end








