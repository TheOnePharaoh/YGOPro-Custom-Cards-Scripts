--Toon Ebon Illusion Magician
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
    --remove
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(s_id,0))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,s_id)
    e5:SetCondition(scard.rmcon)
    e5:SetTarget(scard.rmtg)
    e5:SetOperation(scard.rmop)
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

function scard.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    return tc:IsType(TYPE_TOON)
end
function scard.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function scard.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end