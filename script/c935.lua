--Accel Vocaloid Kaito - The Thousand Years Solo
function c935.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Synchro Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(935,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c935.syncon)
	e1:SetOperation(c935.synop)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(935,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c935.drcon)
	e2:SetTarget(c935.drtg)
	e2:SetOperation(c935.drop)
	c:RegisterEffect(e2)
	--synchro summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(935,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c935.drcon2)
	e3:SetTarget(c935.drtarg2)
	e3:SetOperation(c935.drop2)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(935,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c935.thcost)
	e4:SetTarget(c935.thtg)
	e4:SetOperation(c935.thop)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c935.con2)
	e5:SetValue(c935.tgvalue)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c935.con)
	e6:SetOperation(c935.op)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(935,4))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCost(c935.spcost)
	e7:SetTarget(c935.sptg)
	e7:SetOperation(c935.spop)
	c:RegisterEffect(e7)
	--token
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e8:SetDescription(aux.Stringid(935,5))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCode(EVENT_BATTLE_DESTROYED)
	e8:SetCondition(c935.tokencon)
	e8:SetTarget(c935.tokentg)
	e8:SetOperation(c935.tokenop)
	c:RegisterEffect(e8)
end
function c935.matfilter1(c,syncard)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c935.matfilter2(c,syncard)
	return c:IsFaceup() and c:IsCode(58656934) and c:IsCanBeSynchroMaterial(syncard)
end
function c935.synfilter1(c,syncard,lv,g1,g2)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	return g1:IsExists(c935.synfilter2,1,c,syncard,lv-tlv,g2,f1,c)
end
function c935.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c934.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
end
function c935.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c935.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=Duel.GetMatchingGroup(c935.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c935.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c935.synfilter2,1,tuner,c,lv-tlv,g2,f1,tuner)
		else
			return c934.synfilter2(pe:GetOwner(),c,lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c935.synfilter1,1,nil,c,lv,g1,g2)
	else
		return c935.synfilter1(pe:GetOwner(),c,lv,g1,g2)
	end
end
function c935.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c935.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c935.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c935.synfilter2,1,1,tuner,c,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c935.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c935.synfilter1,1,1,nil,c,lv,g1,g2)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t2=g1:FilterSelect(tp,c935.synfilter2,1,1,tuner1,c,lv-lv1,g2,f1,tuner1)
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c935.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c935.drawfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c935.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c935.drawfilter,1,nil)
end
function c935.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c935.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c935.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c935.drtarg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,5)
end
function c935.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Draw(1-tp,2,REASON_EFFECT)
end
function c935.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function c935.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c935.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c935.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c935.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c935.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c935.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c935.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and not c:IsCode(935)
end
function c935.con2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c934.tgfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c935.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c935.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c935.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c935.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c935.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c935.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c935.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,6000) end
	Duel.PayLPCost(tp,6000)
end
function c935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c935.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c935.tokenfilter(c,tp)
	return c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TOKEN)
end
function c935.tokencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c935.tokenfilter,1,nil,tp)
end
function c935.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c935.tokenop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,936,0,0x4011,250,250,1,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,936)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
