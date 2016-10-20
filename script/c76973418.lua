--Corrupted Vocaloid Sekka Yuffu Type - 09
function c76973418.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c76973418.syncon)
	e1:SetOperation(c76973418.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c76973418.limitoperation)
	c:RegisterEffect(e2)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76973418,0))
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCondition(aux.bdogcon)
	e3:SetOperation(c76973418.spop)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c76973418.con)
	e4:SetOperation(c76973418.op)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c76973418.encfilter)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c76973418.encfilter)
	e6:SetValue(500)
	c:RegisterEffect(e6)
end
function c76973418.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c76973418.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c76973418.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
	return g1:IsExists(c76973418.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c76973418.synfilter3,1,nil,lv-tlv)
	end	
end
function c76973418.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c76973418.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c76973418.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973418.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c76973418.synfilter1,1,nil,lv,g1,g2)
end
function c76973418.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c76973418.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973418.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c76973418.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c76973418.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c76973418.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973418,1))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973418,2))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973418,3))
end
function c76973418.limitoperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c76973418.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c76973418.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c76973418.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c76973418.sumcon)
	e1:SetTarget(c76973418.sumlimit)
	e1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c76973418.sumcon(e)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c76973418.sumlimit(e,c)
	return c:IsLevelBelow(4)
end
function c76973418.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c76973418.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c76973418.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c76973418.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c76973418.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c76973418.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c76973418.encfilter(e,c)
	return c:IsType(TYPE_SYNCHRO)
end