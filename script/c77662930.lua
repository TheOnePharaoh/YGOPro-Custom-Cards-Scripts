--Accel Vocaloid Gahata Meiji
function c77662930.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77662930,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c77662930.tdcon)
	e1:SetTarget(c77662930.tdtg)
	e1:SetOperation(c77662930.tdop)
	c:RegisterEffect(e1)
	--LP gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77662930,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c77662930.lpcon)
	e2:SetTarget(c77662930.lptg)
	e2:SetOperation(c77662930.lpop)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c77662930.con)
	e3:SetOperation(c77662930.op)
	c:RegisterEffect(e3)
	--place pcard
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c77662930.pencon)
	e4:SetCost(c77662930.pencost)
	e4:SetTarget(c77662930.pentg)
	e4:SetOperation(c77662930.penop)
	c:RegisterEffect(e4)
end
function c77662930.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77662930.filter1(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsRace(RACE_MACHINE) or c:IsSetCard(0x0dac406)) and c:IsAbleToDeck()
end
function c77662930.filter2(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c77662930.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c77662930.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,nil)
		and Duel.IsExistingTarget(c77662930.filter2,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c77662930.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c77662930.filter2,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,4,0,0)
end
function c77662930.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c77662930.specifilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402) and c:IsPreviousLocation(LOCATION_EXTRA)
		and c:GetPreviousControler()==tp
end
function c77662930.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c77662930.specifilter,1,nil,tp)
end
function c77662930.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c77662930.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c77662930.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c77662930.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c77662930.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c77662930.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c77662930.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c77662930.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c77662930.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77662930.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c77662930.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c77662930.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77662930.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c77662930.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c77662930.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
