--Corrupted Vocaloid IA Type - 01
function c76973411.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c76973411.syncon)
	e1:SetOperation(c76973411.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76973411,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c76973411.drtg)
	e2:SetOperation(c76973411.drop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c76973411.con2)
	e3:SetValue(c76973411.tgvalue)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c76973411.con)
	e4:SetOperation(c76973411.op)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--attack up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(76973411,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(TIMING_DAMAGE_STEP)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,76973411)
	e6:SetCondition(c76973411.atcon)
	e6:SetOperation(c76973411.atop)
	c:RegisterEffect(e6)
	--place pcard
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c76973411.pencon)
	e7:SetCost(c76973411.pencost)
	e7:SetTarget(c76973411.pentg)
	e7:SetOperation(c76973411.penop)
	c:RegisterEffect(e7)
end
function c76973411.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c76973411.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c76973411.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
	return g1:IsExists(c76973411.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c76973411.synfilter3,1,nil,lv-tlv)
	end	
end
function c76973411.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c76973411.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c76973411.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973411.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c76973411.synfilter1,1,nil,lv,g1,g2)
end
function c76973411.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c76973411.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973411.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c76973411.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c76973411.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c76973411.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973411,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973411,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973411,4))
end
function c76973411.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c76973411.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c76973411.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c76973411.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(2)
end
function c76973411.con2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c76973411.tgfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c76973411.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c76973411.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c76973411.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c76973411.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c76973411.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c76973411.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c76973411.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsType(TYPE_SYNCHRO) and tc:IsRelateToBattle()
end
function c76973411.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToBattle() or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(500)
	tc:RegisterEffect(e1)
end
function c76973411.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c76973411.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c76973411.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c76973411.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c76973411.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c76973411.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c76973411.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
