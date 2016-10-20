--Vocaloid Oniko Hinomoto
function c76222.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76222,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c76222.descon)
	e1:SetTarget(c76222.destg)
	e1:SetOperation(c76222.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76222,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c76222.spcon)
	e2:SetTarget(c76222.sptg)
	e2:SetOperation(c76222.spop)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c76222.con)
	e3:SetOperation(c76222.op)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c76222.addfilter)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	--def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c76222.addfilter)
	e5:SetValue(200)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c76222.pencon)
	e6:SetCost(c76222.pencost)
	e6:SetTarget(c76222.pentg)
	e6:SetOperation(c76222.penop)
	c:RegisterEffect(e6)
end
function c76222.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c76222.desfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:IsDestructable()
end
function c76222.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c76222.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c76222.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76222.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c76222.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c76222.spefilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76222.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c76222.spefilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c76222.spefilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76222.spefilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c76222.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() then return end
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c76222.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c76222.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c76222.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c76222.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c76222.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c76222.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c76222.addfilter(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c76222.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c76222.penfilter4(c)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c76222.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c76222.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c76222.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c76222.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c76222.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
