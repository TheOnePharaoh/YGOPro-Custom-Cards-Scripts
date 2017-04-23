--CXyz Idol Master of Leonis Constellation Ran Shibki
function c59821048.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c59821048.atktg)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821048,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c59821048.pencon)
	e2:SetTarget(c59821048.pentg)
	e2:SetOperation(c59821048.penop)
	c:RegisterEffect(e2)
	--tuner related
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c59821048.tunercon)
	e3:SetTarget(c59821048.tunertg)
	e3:SetOperation(c59821048.tunerop)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c59821048.imcon)
	e4:SetValue(c59821048.efilter)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c59821048.indes)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821048,1))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e6:SetCondition(c59821048.drcon)
	e6:SetCost(c59821048.drcost)
	e6:SetTarget(c59821048.drtg)
	e6:SetOperation(c59821048.drop)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c59821048.con)
	e7:SetOperation(c59821048.op)
	c:RegisterEffect(e7)
	--atk,def
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetValue(c59821048.atkval)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	--overtake
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c59821048.overcon)
	e10:SetTarget(c59821048.overtg)
	e10:SetOperation(c59821048.overop)
	c:RegisterEffect(e10)
	--add setcode
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_ADD_SETCODE)
	e11:SetValue(0x1073)
	c:RegisterEffect(e11)
end
function c59821048.atktg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821048.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821048.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821048.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821048.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821048.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821048.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821048.tunerfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c59821048.tunercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c59821048.tunerfilter1,1,nil,tp)
end
function c59821048.tunerfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0xa1a2)) and not c:IsType(TYPE_TUNER) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_SYNCHRO) and not c:IsCode(59821051)
end
function c59821048.tunertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59821048.tunerfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821048.tunerfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821048.tunerfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59821048.tunerop(e,tp,eg,ep,ev,re,r,rp)
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
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end
function c59821048.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821048.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821048.indes(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c59821048.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821048.drawfilter(c)
	return c:IsCode(59821001) or c:IsCode(59821002) or c:IsCode(59821003) or c:IsCode(59821004) or c:IsCode(59821005) or c:IsCode(59821006) or c:IsCode(59821007) or c:IsCode(59821008)  or c:IsCode(59821009) or c:IsCode(59821010) or c:IsCode(59821011) or c:IsCode(59821012) or c:IsCode(59821013) or c:IsCode(59821014) or c:IsCode(59821015) or c:IsCode(59821016) or c:IsCode(59821017) or c:IsCode(59821018) or c:IsCode(59821019) or c:IsCode(59821020) or c:IsCode(59821021) or c:IsCode(59821022) or c:IsCode(59821024) or c:IsCode(59821025) or c:IsCode(59821026) or c:IsCode(59821027) or c:IsCode(59821028) or c:IsCode(59821029) or c:IsCode(59821030) or c:IsCode(59821031) or c:IsCode(59821032) or c:IsCode(59821033) or c:IsCode(59821034) or c:IsCode(59821035) or c:IsCode(59821036) or c:IsCode(59821037) or c:IsCode(59821038) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821047) or c:IsCode(59821048) or c:IsCode(59821049) and c:IsAbleToDeck()
end
function c59821048.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821048.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c59821048.drawfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.IsExistingTarget(c59821048.drawfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c59821048.drawfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c59821048.targetfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c59821048.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c59821048.targetfilter,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c59821048.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821048.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821048.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821048.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821048.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821048.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821048.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*200
end
function c59821048.overlayfilter(c)
	return c:IsCode(59821003) or c:IsHasEffect(59821167)
end
function c59821048.overcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c59821048.overlayfilter,1,nil)
end
function c59821048.overfilter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c59821048.overtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59821048.overfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c59821048.overfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59821048.overfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c59821048.overop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end