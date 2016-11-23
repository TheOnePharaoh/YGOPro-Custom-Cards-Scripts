--Necro Doll – Maylin Twilight Hope
function c494476154.initial_effect(c)
    local g=Group.CreateGroup()
    g:KeepAlive()
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x600),8,5)
    c:EnableReviveLimit()
    --Double
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(494476154,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(c494476154.atkcon)
    e1:SetOperation(c494476154.atkop)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(494476154,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCondition(c494476154.spcon)
    e2:SetTarget(c494476154.sptg)
    e2:SetOperation(c494476154.spop)
    c:RegisterEffect(e2)
    --Activate Limit
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(494476154,2))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(TIMING_BATTLE_START)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c494476154.accon)
    e3:SetCost(c494476154.accost)
    e3:SetOperation(c494476154.acop)
    c:RegisterEffect(e3)
    --negate gain LP
   local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(494476154,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c494476154.nacon)
	e4:SetCost(c494476154.nacost)
	e4:SetOperation(c494476154.naop)
	c:RegisterEffect(e4)
  --attribute
  local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e5)
  --indes
  local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c494476154.indes)
	c:RegisterEffect(e6)
local e7=e6:Clone()
  e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e7)
  --activate
  local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCondition(c494476154.condition)
	e8:SetTarget(c494476154.target)
	e8:SetOperation(c494476154.activate)
	c:RegisterEffect(e1)
	if not c494476154.global_check then
		c494476154.global_check=true
		c494476154[0]=false
		c494476154[1]=false
		c494476154[2]=Group.CreateGroup()
		c494476154[2]:KeepAlive()
		c494476154[3]=Group.CreateGroup()
		c494476154[3]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c494476154.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c494476154.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		ge3:SetCode(EVENT_REMOVE)
		ge3:SetOperation(c494476154.matchk)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_TO_HAND)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		ge6:SetCode(EVENT_TO_GRAVE)
		Duel.RegisterEffect(ge6,0)
		local ge7=ge3:Clone()
		ge7:SetCode(EVENT_LEAVE_FIELD)
		Duel.RegisterEffect(ge7,0)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e9:SetCode(EVENT_ADJUST)
	e9:SetCountLimit(1)
	e9:SetOperation(c494476154.chk)
	e9:SetLabelObject(e1)
	Duel.RegisterEffect(e9,0)
end

function c494476154.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:GetAttribute()~=c:GetAttribute()
end
function c494476154.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetValue(bc:GetAttack()*2)
        c:RegisterEffect(e1)
    end
end
function c494476154.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not c:IsRelateToBattle() or c:IsFacedown() then return false end
    return bc and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c494476154.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetTargetCard(bc)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c494476154.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
     local e1=Effect.CreateEffect(e:GetHandler())
     e1:SetType(EFFECT_TYPE_SINGLE)
     e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
     e1:SetCode(EFFECT_TYPE_CHANGE_CODE)
     e1:SetValue(0x600)
     e1:SetReset(RESET_EVENT+0x1fe0000)
     tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetValue(0)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2,true)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_SET_DEFENSE)
        tc:RegisterEffect(e3,true)
        Duel.SpecialSummonComplete()
    end
end
function c494476154.accon(e,tp,eg,ep,ev,re,r,rp)
    return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and not Duel.CheckPhaseActivity()
end
function c494476154.accost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c494476154.acop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(c494476154.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
    Duel.RegisterEffect(e1,tp)
end
function c494476154.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c494476154.nacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return bt:GetControler()==c:GetControler()
end
function c494476154.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c494476154.naop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.Recover(e:GetHandler():GetControler(),Duel.GetAttacker():GetAttack(),REASON_EFFECT)
	end
end
function c494476154.indes(e,c)
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

function c494476154.cfilter(c)
	return c:GetPreviousCodeOnField()==494476154
end
function c494476154.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c494476154.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		c494476154[tc:GetPreviousControler()]=true
		tc=g:GetNext()
	end
end
function c494476154.matchk(e,tp,eg,ep,ev,re,r,rp)
	c494476154[2]:Clear()
	c494476154[3]:Clear()
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x33)
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,1-tp,LOCATION_GRAVE,0,nil,0x33)
	local tc1=g1:GetFirst()
	while tc1 do
		local token=Duel.CreateToken(tp,tc1:GetOriginalCode())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(12)
		token:RegisterEffect(e1)
		c511000295[tp+2]:AddCard(token)
		tc1=g1:GetNext()
	end
	local tc2=g2:GetFirst()
	while tc2 do
		local token=Duel.CreateToken(1-tp,tc2:GetOriginalCode())
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(12)
		token:RegisterEffect(e2)
		c494476154[1-tp+2]:AddCard(token)
		tc2=g2:GetNext()
	end
end
function c494476154.clear(e,tp,eg,ep,ev,re,r,rp)
	c494476154[0]=false
	c494476154[1]=false
end
function c494476154.chk(e,tp,eg,ep,ev,re,r,rp)
	local tck=Duel.CreateToken(tp,419)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(12)
	tck:RegisterEffect(e1)
	e:GetLabelObject():SetLabelObject(tck)
end
function c494476154.condition(e,tp,eg,ep,ev,re,r,rp)
	return c494476154[tp]
end
function c494476154.mfilter(c,xyz,tck)
	return xyz.xyz_filter(tck) and c:IsCode(494476154)
end
function c494476154.matfilter(c,xyz)
	return xyz.xyz_filter(c) and c:IsSetCard(0x33)
end
function c494476154.xyzfilter(c,e,tp,tck)
	return c:GetRank()==12 and c.xyz_count==5 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(c494476154.mfilter,tp,LOCATION_GRAVE,0,1,nil,c,tck)
		and c511000295[tp+2]:IsExists(c494476154.matfilter,4,nil,c)
end
function c494476154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tck=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c494476154.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tck) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c494476154.activate(e,tp,eg,ep,ev,re,r,rp)
	local tck=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c511000295.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tck)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mat1=Duel.SelectMatchingCard(tp,c511000295.mfilter,tp,LOCATION_GRAVE,0,1,1,nil,xyz,tck)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x48)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(12)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local mat2=g:FilterSelect(tp,c494476154.matfilter,4,4,nil,xyz)
		mat1:Merge(mat2)
		Duel.HintSelection(mat1)
		xyz:SetMaterial(mat1)
		Duel.Overlay(xyz,mat1)
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		xyz:CompleteProcedure()
	end
end









