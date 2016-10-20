--Accel Vocaloid Kasane Teto - Pendulum Form
function c934.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(934,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c934.syncon)
	e1:SetOperation(c934.synop)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(934,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c934.atkcon)
	e2:SetOperation(c934.atkop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c934.con2)
	e3:SetValue(c934.tgvalue)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetCondition(c934.con2)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c934.con)
	e5:SetOperation(c934.op)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c934.pencon)
	e6:SetCost(c934.pencost)
	e6:SetTarget(c934.pentg)
	e6:SetOperation(c934.penop)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e7:SetValue(c934.encorefilter)
	c:RegisterEffect(e7)
	--pendulum indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetCountLimit(1)
	e8:SetValue(1)
	c:RegisterEffect(e8)
end
function c934.matfilter1(c,syncard)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c934.matfilter2(c,syncard)
	return c:IsFaceup() and c:IsCode(52414158) or c:IsCode(90139917) and c:IsCanBeSynchroMaterial(syncard)
end
function c934.synfilter1(c,syncard,lv,g1,g2)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c934.synfilter2,1,c,syncard,lv-tlv,g2,f1,c)
end
function c934.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c934.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
end
function c934.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c934.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c934.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c934.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c934.synfilter2,1,tuner,c,lv-tlv,g2,f1,tuner)
		else
			return c934.synfilter2(pe:GetOwner(),c,lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c934.synfilter1,1,nil,c,lv,g1,g2)
	else
		return c934.synfilter1(pe:GetOwner(),c,lv,g1,g2)
	end
end
function c934.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c934.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c934.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c934.synfilter2,1,1,tuner,c,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c934.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c934.synfilter1,1,1,nil,c,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c934.synfilter2,1,1,tuner1,c,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c934.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c934.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c934.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)
end
function c934.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c934.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c934.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c934.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and not c:IsCode(934)
end
function c934.con2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c934.tgfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c934.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c934.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c934.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c934.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c934.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c934.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c934.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c934.penfilter4(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c934.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c934.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c934.penfilter4,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c934.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c934.penfilter4,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c934.encorefilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and not re:IsType(TYPE_SYNCHRO)
end
