--S. Vocaloid oliver
function c66652242.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c66652242.thcon)
	e1:SetTarget(c66652242.thtg)
	e1:SetOperation(c66652242.thop)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66652242.pencon)
	e2:SetCost(c66652242.pencost)
	e2:SetTarget(c66652242.pentg)
	e2:SetOperation(c66652242.penop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c66652242.splimit)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c66652242.dacon)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c66652242.con)
	e5:SetOperation(c66652242.op)
	c:RegisterEffect(e5)
	--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c66652242.splimit)
	c:RegisterEffect(e6)
end
function c66652242.thcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsType(TYPE_FUSION) or a:IsType(TYPE_SYNCHRO)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c66652242.searchfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c66652242.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652242.searchfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66652242.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66652242.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66652242.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c66652242.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c66652242.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c66652242.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66652242.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c66652242.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c66652242.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c66652242.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652242.dafilter(c)
	return c:IsFaceup() and c:GetSequence()~=5
end
function c66652242.dacon(e)
	return Duel.IsExistingMatchingCard(c66652242.dafilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c66652242.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652242.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652242.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652242.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652242.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652242.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c66652242.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end