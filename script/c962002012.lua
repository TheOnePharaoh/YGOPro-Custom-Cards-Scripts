--Toon Trishula, Dragon of the Ice Barrier
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
    e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1)
    e5:SetTarget(scard.remtg)
    e5:SetOperation(scard.remop)
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

function scard.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x1e,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1e)
end
function scard.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local sg=Group.CreateGroup()
    if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(s_id,1))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        sg:Merge(sg1)
    end
    if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(s_id,2))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.HintSelection(sg2)
        sg:Merge(sg2)
    end
    if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(s_id,3))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg3=g3:RandomSelect(tp,1)
        sg:Merge(sg3)
    end
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
