--The Future Gear Gigas the Vermilion
function c99199012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c99199012.atkval)
	c:RegisterEffect(e1)
	--Negate Effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199012,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99199012)
	e2:SetTarget(c99199012.negtg)
	e2:SetOperation(c99199012.negop)	
	c:RegisterEffect(e2)
	--tuner related
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99199012.tunercon)
	e3:SetTarget(c99199012.tunertg)
	e3:SetOperation(c99199012.tunerop)
	c:RegisterEffect(e3)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c99199012.sccon)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c99199012.con)
	e6:SetOperation(c99199012.op)
	c:RegisterEffect(e6)
	--place pcard
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(99199012,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1,99199012)
	e7:SetCondition(c99199012.pencon)
	e7:SetCost(c99199012.pencost)
	e7:SetTarget(c99199012.pentg)
	e7:SetOperation(c99199012.penop)
	c:RegisterEffect(e7)
	--splimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(c99199012.splimit)
	e8:SetCondition(c99199012.splimcon)
	c:RegisterEffect(e8)
end
function c99199012.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT)*200
end
function c99199012.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99199012.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c99199012.tunerfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199012.tunercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199012.tunerfilter1,1,nil,tp)
end
function c99199012.tunerfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0xff15)) and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ)
end
function c99199012.tunertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199012.tunerfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199012.tunerfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99199012.tunerfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99199012.tunerop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end
function c99199012.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199012.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199012.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199012.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199012.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199012.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199012.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199012.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199012.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199012.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199012.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199012.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199012.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199012.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199012.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199012.splimcon(e)
	return not e:GetHandler():IsForbidden()
end