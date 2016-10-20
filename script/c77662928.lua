--Vocaloid Ultimate Alternation Haku Yowane
function c77662928.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c77662928.xyzcon)
	e1:SetOperation(c77662928.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77662928.atkval)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77662928,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,77662928)
	e3:SetTarget(c77662928.copytg)
	e3:SetOperation(c77662928.copyop)
	c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c77662928.splimit)
	e4:SetCondition(c77662928.splimcon)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c77662928.con)
	e5:SetOperation(c77662928.op)
	c:RegisterEffect(e5)
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c77662928.sccon)
	e6:SetValue(3)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7)
	--lv change
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77662928,2))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1,77662928)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c77662928.lvtg)
	e8:SetOperation(c77662928.lvop)
	c:RegisterEffect(e8)
	--def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(c77662928.atkval)
	c:RegisterEffect(e9)
	--place pcard
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77662928,5))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCountLimit(1,77662928)
	e10:SetCondition(c77662928.pencon)
	e10:SetCost(c77662928.pencost)
	e10:SetTarget(c77662928.pentg)
	e10:SetOperation(c77662928.penop)
	c:RegisterEffect(e10)
end
function c77662928.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x0dac404) and c:GetOverlayCount()>0 and c:IsCanBeXyzMaterial(xyzc)
end
function c77662928.xyzfilter1(c,g,ct)
	return g:IsExists(c77662928.xyzfilter2,ct,c,c:GetRank())
end
function c77662928.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c77662928.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(1,-ft)
	local mg=Duel.GetMatchingGroup(c77662928.mfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(c77662928.xyzfilter1,1,nil,mg,ct)
end
function c77662928.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.max(1,-ft)
	local mg=Duel.GetMatchingGroup(c77662928.mfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c77662928.xyzfilter1,1,1,nil,mg,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c77662928.xyzfilter2,ct,63,g1:GetFirst(),g1:GetFirst():GetRank())
	g1:Merge(g2)
	local sg=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c77662928.atkval(e,c)
	return c:GetOverlayCount()*800
end
function c77662928.filter(c)
	return c:IsSetCard(0x0dac404) and c:IsType(TYPE_EFFECT)
end
function c77662928.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c77662928.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77662928.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c77662928.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c77662928.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetLabel(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(77662928,4))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c77662928.rstcon)
		e2:SetOperation(c77662928.rstop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	end
end
function c77662928.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	return Duel.GetTurnPlayer()~=e1:GetLabel()
end
function c77662928.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c77662928.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_MACHINE) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77662928.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c77662928.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c77662928.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c77662928.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c77662928.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c77662928.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c77662928.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c77662928.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not tc:IsCode(98442213) and not tc:IsCode(98442212) and not tc:IsCode(38299892) and not tc:IsCode(38299891) and not tc:IsCode(77662914) and not tc:IsCode(77662928))
end
function c77662928.desfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c77662928.descon(e)
	return Duel.IsExistingMatchingCard(c77662928.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c77662928.levelfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405)
end
function c77662928.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77662928.levelfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77662914,3))
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10)
	e:SetLabel(lv)
end
function c77662928.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77662928.levelfilter,tp,LOCATION_MZONE,0,nil)
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
function c77662928.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c77662928.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c77662928.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c77662928.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77662928.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c77662928.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c77662928.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end