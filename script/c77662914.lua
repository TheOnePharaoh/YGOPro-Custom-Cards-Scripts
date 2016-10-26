--Vocalist Alternation Hakaine Maiko
function c77662914.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),7,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--xyz summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77662914,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77662914.drcon)
	e1:SetTarget(c77662914.drtarg)
	e1:SetOperation(c77662914.drop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77662914,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77662914.spcon)
	e2:SetTarget(c77662914.sptg)
	e2:SetOperation(c77662914.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77662914,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77662914.discon)
	e3:SetCost(c77662914.discost)
	e3:SetTarget(c77662914.distg)
	e3:SetOperation(c77662914.disop)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c77662914.splimit)
	e4:SetCondition(c77662914.splimcon)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c77662914.con)
	e5:SetOperation(c77662914.op)
	c:RegisterEffect(e5)
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c77662914.sccon)
	e6:SetValue(3)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7)
	--lv change
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77662914,3))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c77662914.lvtg)
	e8:SetOperation(c77662914.lvop)
	c:RegisterEffect(e8)
end
function c77662914.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77662914.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77662914.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c77662914.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct1>=ct2 then return false end
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c77662914.specfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c77662914.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	local count=0
	local tc=g:GetFirst()
	while tc do
		if c77662914.specfilter(tc,e,tp) then
			count=count+1
		end
		tc=g:GetNext()
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>=count end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c77662914.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_INITIAL+EFFECT_FLAG_REPEAT)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c77662914.retcon)
	e1:SetOperation(c77662914.retop)
	c:RegisterEffect(e1)
	local sg=g:FilterSelect(tp,c77662914.specfilter,g:GetCount(),g:GetCount(),nil,e,tp)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c77662914.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetCardTarget()
	return tc:GetCount()>0
end
function c77662914.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.Overlay(c,tc)
		end
		tc=g:GetNext()
	end
end
function c77662914.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c77662914.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c77662914.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77662914.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c77662914.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_MACHINE) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77662914.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c77662914.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c77662914.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c77662914.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c77662914.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c77662914.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c77662914.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c77662914.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not tc:IsCode(98442213) and not tc:IsCode(98442212) and not tc:IsCode(38299892) and not tc:IsCode(38299891) and not tc:IsCode(77662914) and not tc:IsCode(77662928))
end
function c77662914.desfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c77662914.descon(e)
	return Duel.IsExistingMatchingCard(c77662914.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c77662914.levelfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405)
end
function c77662914.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77662914.levelfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77662914,4))
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10)
	e:SetLabel(lv)
end
function c77662914.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77662914.levelfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end