--Corrupted Vocaloid Hatsune Miku Type - 39
function c76973415.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c76973415.syncon)
	e1:SetOperation(c76973415.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76973415,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c76973415.condition)
	e2:SetTarget(c76973415.target)
	e2:SetOperation(c76973415.operation)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c76973415.con)
	e3:SetOperation(c76973415.op)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e4:SetValue(c76973415.immunefilter)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(76973415,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(c76973415.atktg)
	e5:SetOperation(c76973415.atkop)
	c:RegisterEffect(e5)
end
function c76973415.matfilter1(c,syncard)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c76973415.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c76973415.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(100000147)==0 then	
	return g1:IsExists(c76973415.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c76973415.synfilter3,1,nil,lv-tlv)
	end	
end
function c76973415.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c76973415.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c76973415.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973415.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c76973415.synfilter1,1,nil,lv,g1,g2)
end
function c76973415.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c76973415.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c76973415.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c76973415.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(100000147)==0 then	
		local t1=g1:FilterSelect(tp,c76973415.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c76973415.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973415,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973415,3))
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(76973415,4))
end
function c76973415.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c76973415.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		if tc:IsFaceup() and not tc:IsRace(RACE_MACHINE) then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	end
end
function c76973415.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) and not tc:IsRace(RACE_MACHINE) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c76973415.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c76973415.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c76973415.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c76973415.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c76973415.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c76973415.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c76973415.immunefilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL)
end
function c76973415.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c76973415.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c76973415.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76973415.atkfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c76973415.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c76973415.atkfilter2,tp,LOCATION_ONFIELD,0,nil)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end