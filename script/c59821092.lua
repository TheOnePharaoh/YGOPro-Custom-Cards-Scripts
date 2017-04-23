--CXyz Idol Master The Deity of Evil Zobek
function c59821092.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-200)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821092,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,59821092)
	e2:SetCondition(c59821092.pencon)
	e2:SetTarget(c59821092.pentg)
	e2:SetOperation(c59821092.penop)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x1073)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c59821092.con)
	e4:SetOperation(c59821092.op)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c59821092.imcon)
	e5:SetValue(c59821092.efilter)
	c:RegisterEffect(e5)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c59821092.indes)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c59821092.indtg)
	c:RegisterEffect(e7)
	--disable spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,1)
	e8:SetTarget(c59821092.sumlimit)
	e8:SetCondition(c59821092.dscon)
	c:RegisterEffect(e8)
	--damage
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e9:SetCondition(c59821092.damcon)
	e9:SetCost(c59821092.damcost)
	e9:SetOperation(c59821092.damop)
	c:RegisterEffect(e9)
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(59821092,1))
	e10:SetCategory(CATEGORY_ATKCHANGE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(c59821092.atkchacon)
	e10:SetOperation(c59821092.atkchaop)
	c:RegisterEffect(e10)
	--cannot trigger
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_TRIGGER)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c59821092.disacon)
	e11:SetTargetRange(0,LOCATION_MZONE)
	e11:SetTarget(c59821092.disatg)
	c:RegisterEffect(e11)
end
function c59821092.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821092.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821092.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821092.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821092.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821092.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821092.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821092.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821092.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821092.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821092.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821092.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c59821092.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821092.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821092.indes(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c59821092.indtg(e,c)
	return c:IsSetCard(0xa1a2) and c:IsCode(59821039) and c:IsCode(59821040) and c:IsCode(59821041) and c:IsCode(59821042) and c:IsCode(59821043) and c:IsCode(59821044) and c:IsCode(59821045) and c:IsCode(59821046) and c:IsCode(59821048) and c:IsCode(59821085)
end
function c59821092.dscon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xa1a2)
end
function c59821092.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRankAbove(6)
end
function c59821092.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821092.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821092.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2000,REASON_EFFECT)
end
function c59821092.atkchacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c59821092.atkchafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821092.atkchaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821092.atkchafilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c59821092.overlayfilter(c)
	return c:IsCode(59821009) or c:IsHasEffect(59821167)
end
function c59821092.disacon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c59821092.overlayfilter,1,nil)
end
function c59821092.disatg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
