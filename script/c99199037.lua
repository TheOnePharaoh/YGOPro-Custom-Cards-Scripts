--Future Gear Arch Alexander the Living Fortress Dragon
function c99199037.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),7,3,c99199037.ovfilter,aux.Stringid(99199037,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99199037.atkval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c99199037.unicon)
	e2:SetValue(c99199037.efilter)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c99199037.splimit)
	e3:SetCondition(c99199037.splimcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DRAW)
	e4:SetCondition(c99199037.drcon)
	e4:SetTarget(c99199037.drtg)
	e4:SetOperation(c99199037.drop)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c99199037.con)
	e5:SetOperation(c99199037.op)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99199037,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,99199037)
	e6:SetCondition(c99199037.pencon)
	e6:SetCost(c99199037.pencost)
	e6:SetTarget(c99199037.pentg)
	e6:SetOperation(c99199037.penop)
	c:RegisterEffect(e6)
	--tuner related
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(99199037,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1,99199037)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCost(c99199037.pencost)
	e7:SetTarget(c99199037.lvtg)
	e7:SetOperation(c99199037.lvop)
	c:RegisterEffect(e7)
	--draw
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetCondition(c99199037.tdcon)
	e8:SetTarget(c99199037.tdtg)
	e8:SetOperation(c99199037.tdop)
	c:RegisterEffect(e8)
	--lock
	local e9=Effect.CreateEffect(c)
	e9:SetCode(EFFECT_DISABLE_FIELD)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetCondition(c99199037.lkcon)
	e9:SetOperation(c99199037.lkop)
	c:RegisterEffect(e9)
	--activate limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetHintTiming(0,TIMING_DRAW_PHASE)
	e10:SetCountLimit(1)
	e10:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c99199037.unicon)
	e10:SetCost(c99199037.sealcost)
	e10:SetOperation(c99199037.sealoperation)
	c:RegisterEffect(e10)
end
function c99199037.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99199037.lkop(e,tp,eg,ep,ev,re,r,rp)
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c99199037.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c99199037.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(99199037,3)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(99199037,3)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,dis1)
			dis1=bit.bor(dis1,dis3)
		end
	end
	return dis1
end
function c99199037.sealcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99199037.sealoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c99199037.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99199037.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function c99199037.unicon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xff15)
end
function c99199037.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c99199037.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==6 and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199037.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsAttribute,2,2,nil,ATTRIBUTE_LIGHT)
	Duel.Release(g,REASON_COST)
end
function c99199037.atkval(e,c)
	return Duel.GetMatchingGroupCount(c99199037.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*400
end
function c99199037.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199037.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99199037.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199037.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199037.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c99199037.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c99199037.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c99199037.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199037.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199037.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199037.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199037.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199037.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199037.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199037.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199037.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199037.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199037.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199037.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199037.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199037.tunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c99199037.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199037.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199037.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99199037.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
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
function c99199037.lvop(e,tp,eg,ep,ev,re,r,rp)
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
function c99199037.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c99199037.drawfilter(c)
	return c:IsSetCard(0xff15) and not c:IsCode(99199037) and c:IsAbleToDeck()
end
function c99199037.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99199037.drawfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.IsExistingTarget(c99199037.drawfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c99199037.drawfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c99199037.targetfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c99199037.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c99199037.targetfilter,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end