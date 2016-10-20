--The Future Gear Arch Duke
function c99199033.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99199033.splimit)
	e1:SetCondition(c99199033.splimcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c99199033.efilter)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199033,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c99199033.thtg)
	e3:SetOperation(c99199033.thop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199033,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c99199033.discon)
	e4:SetCost(c99199033.discost)
	e4:SetTarget(c99199033.distg)
	e4:SetOperation(c99199033.disop)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c99199033.con)
	e5:SetOperation(c99199033.op)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99199033,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,99199033)
	e6:SetCondition(c99199033.pencon)
	e6:SetCost(c99199033.pencost)
	e6:SetTarget(c99199033.pentg)
	e6:SetOperation(c99199033.penop)
	c:RegisterEffect(e6)
	--tuner related
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(99199033,3))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1,99199033)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCost(c99199033.pencost)
	e7:SetTarget(c99199033.lvtg)
	e7:SetOperation(c99199033.lvop)
	c:RegisterEffect(e7)
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.synlimit)
	c:RegisterEffect(e8)
	--atk up
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c99199033.atkcon)
	e9:SetOperation(c99199033.atkop)
	c:RegisterEffect(e9)
end
function c99199033.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199033.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199033.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99199033.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c99199033.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c99199033.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199033.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c99199033.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99199033.sumfilter(c)
	return c:IsSetCard(0xff15) and c:IsSummonable(true,nil)
end
function c99199033.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c99199033.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			end
	end
end
function c99199033.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and tp==Duel.GetTurnPlayer()
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c99199033.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsDestructable() and c:IsType(TYPE_PENDULUM)
end
function c99199033.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199033.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99199033.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c99199033.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c99199033.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c99199033.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(c99199033.bantg)
	e2:SetLabel(ac)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c99199033.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
function c99199033.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function c99199033.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199033.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199033.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199033.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199033.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199033.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199033.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199033.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199033.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199033.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199033.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199033.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199033.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199033.tunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c99199033.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199033.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199033.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99199033.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=1
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=1,6 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c99199033.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
	end
end
function c99199033.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetControler()~=tp then a,d=d,a end
	return d and a:GetControler()~=d:GetControler() and a==e:GetHandler()
end
function c99199033.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetAttack()+500)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end