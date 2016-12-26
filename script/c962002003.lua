-- Toon 
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
   --negate
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(s_id,0))
    e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(scard.condition)
    e5:SetTarget(scard.target)
    e5:SetOperation(scard.operation)
    c:RegisterEffect(e5)
    --atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(scard.atkcon)
    e6:SetOperation(scard.atkop)
    c:RegisterEffect(e6)
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
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if not g or g:GetCount()~=1 then return false end
    local tc=g:GetFirst()
    local c=e:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) then 
        Duel.Destroy(rc,REASON_EFFECT)
    end
end
function scard.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0 and re and re:GetOwner()==e:GetHandler()
        and eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function scard.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
    local c=e:GetHandler()
    local atk=0
    local tc=g:GetFirst()
    while tc do
        if tc:GetTextAttack()>0 then
            atk=atk+tc:GetTextAttack()
        end
        tc=g:GetNext()
    end
    if atk>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end