--Vocaloid Mew
function c9999863.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TUNER))
	e1:SetValue(c9999863.indval)
	c:RegisterEffect(e1)
	--cannot negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9999863.chainfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9999863.chainfilter)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c9999863.con)
	e4:SetOperation(c9999863.op)
	c:RegisterEffect(e4)
	--cannot negate2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c9999863.chainfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9999863.chainfilter)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9999863,0))
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c9999863.negcost)
	e7:SetTarget(c9999863.negtarget)
	e7:SetOperation(c9999863.negoperation)
	c:RegisterEffect(e7)
end
function c9999863.indval(e,c)
	return not c:IsType(TYPE_TUNER)
end
function c9999863.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsSetCard(0x0dac406)
end
function c9999863.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c9999863.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c9999863.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c9999863.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c9999863.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c9999863.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c9999863.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
function c9999863.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9999863.negtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9999863.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9999863.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9999863.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9999863.negoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c9999863.jamfilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c9999863.jamfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
