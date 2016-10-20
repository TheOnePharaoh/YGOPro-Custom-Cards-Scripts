--S. Pair Vocaloids
function c66652244.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunction(Card.IsType,TYPE_XYZ),true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--force detach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66652244,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e1:SetCountLimit(1,66652244)
	e1:SetCondition(c66652244.detcon)
	e1:SetTarget(c66652244.dettg)
	e1:SetOperation(c66652244.detop)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66652244.pencon)
	e2:SetCost(c66652244.pencost)
	e2:SetTarget(c66652244.pentg)
	e2:SetOperation(c66652244.penop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c66652244.splimit)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c66652244.val)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66652244,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c66652244.damcon)
	e5:SetTarget(c66652244.damtg)
	e5:SetOperation(c66652244.damop)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c66652244.con)
	e6:SetOperation(c66652244.op)
	c:RegisterEffect(e6)
end
function c66652244.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652244.detcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c66652244.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
end
function c66652244.detop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,1,REASON_EFFECT)
	if sg:GetCount()==0 then return end
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652244,0))
		sg=sg:Select(tp,0,1,nil)
		Duel.HintSelection(sg)
	end
	sg:GetFirst():RemoveOverlayCard(tp,0,1,REASON_EFFECT)
end
function c66652244.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c66652244.val(e,c)
	return Duel.GetMatchingGroupCount(c66652244.atkfilter,c:GetControler(),0,LOCATION_MZONE,c)*500
end
function c66652244.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ
end
function c66652244.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(eg:GetFirst():GetSummonPlayer())
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,eg:GetFirst():GetSummonPlayer(),500)
end
function c66652244.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if not Duel.IsPlayerAffectedByEffect(p,37511832) then
			Duel.Damage(p,d,REASON_EFFECT)
		end
	end
end
function c66652244.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c66652244.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c66652244.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c66652244.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66652244.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c66652244.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c66652244.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c66652244.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652244.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652244.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652244.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652244.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652244.penfilter2,tp,LOCATION_SZONE,0,nil)
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