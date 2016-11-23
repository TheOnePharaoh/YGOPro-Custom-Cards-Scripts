--Twisted Rin Kagamine
function c66652241.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,false)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c66652241.splimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c66652241.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spsummon count limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c66652241.sumlimit)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c66652241.con)
	e4:SetOperation(c66652241.op)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c66652241.tgtg)
	e5:SetValue(c66652241.tgval)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66652241,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetTarget(c66652241.atktg)
	e6:SetOperation(c66652241.atkop)
	c:RegisterEffect(e6)
end
function c66652241.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652241.tgcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() or Duel.GetCurrentPhase()~=PHASE_BATTLE
end
function c66652241.sumlimit(e,c,sp,st)
	return not c:IsRace(RACE_MACHINE) and Duel.GetFieldGroupCount(sp,LOCATION_MZONE,0)>=1
end
function c66652241.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652241.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652241.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652241.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652241.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652241.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c66652241.tgtg(e,c)
	return c:IsType(TYPE_FUSION)
end
function c66652241.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c66652241.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66652241.atkupfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c66652241.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c66652241.atkupfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c66652241.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	e:GetHandler():RegisterFlagEffect(66652241,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c66652241.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(66652241)
end
function c66652241.econ(e)
	return e:GetHandler():GetFlagEffect(66652241+1)~=0
end
function c66652241.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	e:GetHandler():RegisterFlagEffect(66652241+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c66652241.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(66652241+1)
end
function c66652241.elimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
