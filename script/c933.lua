--Accel Vocaloid Hatsune Miku - Final Form
function c933.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(933,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c933.syncon)
	e1:SetOperation(c933.synop)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c933.atkval)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c933.indes)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c933.tgvalue)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(933,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c933.spcost)
	e5:SetTarget(c933.sptg)
	e5:SetOperation(c933.spop)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c933.con) 
	e6:SetOperation(c933.op)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c933.efilter)
	e7:SetValue(500)
	c:RegisterEffect(e7)
	--def
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c933.efilter)
	e8:SetValue(500)
	c:RegisterEffect(e8)
	--spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(933,2))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCost(c933.spcost)
	e9:SetTarget(c933.tg2)
	e9:SetOperation(c933.op2)
	c:RegisterEffect(e9)
	--pendulum indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e10:SetCountLimit(1)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(933,3))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_BATTLE_DESTROYED)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCondition(c933.spcon3)
	e11:SetCost(c933.spcost3)
	e11:SetTarget(c933.sptg3)
	e11:SetOperation(c933.spop3)
	c:RegisterEffect(e11)
end
function c933.matfilter1(c,syncard)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c933.matfilter2(c,syncard)
	return c:IsFaceup() and c:IsCode(58431891) or c:IsCode(69329489) and c:IsCanBeSynchroMaterial(syncard)
end
function c933.synfilter1(c,syncard,lv,g1,g2)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c933.synfilter2,1,c,syncard,lv-tlv,g2,f1,c)
end
function c933.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c933.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
end
function c933.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c933.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c933.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c933.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c933.synfilter2,1,tuner,c,lv-tlv,g2,f1,tuner)
		else
			return c933.synfilter2(pe:GetOwner(),c,lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c933.synfilter1,1,nil,c,lv,g1,g2)
	else
		return c933.synfilter1(pe:GetOwner(),c,lv,g1,g2)
	end
end
function c933.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c933.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c933.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c933.synfilter2,1,1,tuner,c,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c933.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c933.synfilter1,1,1,nil,c,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c933.synfilter2,1,1,tuner1,c,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c933.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c933.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*500
end
function c933.indes(e,c)
	return not c:IsType(TYPE_SYNCHRO)
end
function c933.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c933.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c933.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetCode()~=933
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c933.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c933.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c933.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c933.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c933.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c933.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c933.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c933.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c933.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c933.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c933.efilter(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c933.spefilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c933.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c933.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c933.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c933.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c933.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c933.cefilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c933.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c933.cefilter,1,nil,tp)
end
function c933.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c933.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end