--Dok'khah, The Divine Order
function c59821159.initial_effect(c)
	c:EnableUnsummonable()
	aux.EnablePendulumAttribute(c,false)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821159,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,59821159)
	e1:SetTarget(c59821159.sctg)
	e1:SetOperation(c59821159.scop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-200)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c59821159.atktg)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--place pcard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821159,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,59821159)
	e4:SetCondition(c59821159.targetcon)
	e4:SetTarget(c59821159.targettg)
	e4:SetOperation(c59821159.targetop)
	c:RegisterEffect(e4)
	--level/rank
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_RANK_LEVEL_S)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c59821159.splimit)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c59821159.con)
	e7:SetOperation(c59821159.op)
	c:RegisterEffect(e7)
	--extra attack
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821159,3))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCondition(c59821159.extcon)
	e8:SetTarget(c59821159.exttg)
	e8:SetOperation(c59821159.extop)
	c:RegisterEffect(e8)
	--immune effect
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(c59821159.immfilter)
	c:RegisterEffect(e9)
	--extra psummon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(59821159,4))
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC_G)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c59821159.pencon)
	e10:SetOperation(c59821159.penop)
	e10:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e10)
	--spsummon cannot negate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e11)
	--upgrade atk
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SET_ATTACK)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c59821159.atkval)
	c:RegisterEffect(e12)
	--damage
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(59821159,5))
	e12:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_XMDETACH)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(c59821159.effcon)
	e12:SetCost(c59821159.effcost)
	e12:SetTarget(c59821159.efftg)
	e12:SetOperation(c59821159.effop)
	c:RegisterEffect(e12)
	--effect
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(59821159,6))
	e13:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e13:SetCode(EVENT_BATTLE_DESTROYING)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCondition(c59821159.condcon)
	e13:SetTarget(c59821159.condtg)
	e13:SetOperation(c59821159.condop)
	c:RegisterEffect(e13)
end
function c59821159.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local ac=e:GetHandler():GetLeftScale()
	for i=1,5 do 
		if ac~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(59821159,2))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c59821159.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function c59821159.atktg(e,c)
	return c:IsSetCard(0xa1a2)
end
function c59821159.targetfilter(c)
    return c:IsSetCard(0xa1a2)
end
function c59821159.targetcon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821159.targettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821159.targetfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821159.targetop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821159.targetfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821159.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(59821157)
end
function c59821159.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821159.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821159.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821159.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821159.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821159.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821159.extcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+400
end
function c59821159.extfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c59821159.exttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c59821159.extfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821159.extfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c59821159.extfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c59821159.extop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c59821159.immfilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c59821159.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden() and c:IsSetCard(0xa1a2)
end
function c59821159.pencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c59821159.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c59821159.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c59821159.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=nil
	if og then
		tg=og:Filter(tp,c59821159.penfilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(c59821159.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale)
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and (ect<=0 or ect>ft) then ect=nil end
	if ect==nil or tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ft,nil)
		sg:Merge(g)
	else
		repeat
			local ct=math.min(ft,ect)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			ft=ft-g:GetCount()
			ect=ect-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		until ft==0 or ect==0 or not Duel.SelectYesNo(tp,210)
		local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		if ft>0 and ect==0 and hg:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=hg:Select(tp,1,ft,nil)
			sg:Merge(g)
		end
	end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c59821159.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0xa1a2)
end
function c59821159.atkval(e,c)
	local g=Duel.GetMatchingGroup(c59821159.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetAttack)
end
function c59821159.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c59821159.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821159.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c59821159.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c59821159.condcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821159.condtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,2,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,2,2,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,2,0,0)
end
function c59821159.condop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end