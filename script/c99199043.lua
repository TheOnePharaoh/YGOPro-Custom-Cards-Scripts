--The Future Gear Arch Luce the Bringer of Creation
function c99199043.initial_effect(c)
	c:SetUniqueOnField(1,0,99199043)
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
	e1:SetTarget(c99199043.splimit1)
	e1:SetCondition(c99199043.splimcon)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c99199043.splimit2)
	c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c99199043.tgvalue)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c99199043.atkval)
	c:RegisterEffect(e5)
	--defup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c99199043.atkval)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c99199043.con)
	e7:SetOperation(c99199043.op)
	c:RegisterEffect(e7)
	--place pcard
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(99199043,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,99199043)
	e8:SetCondition(c99199043.pencon)
	e8:SetCost(c99199043.pencost)
	e8:SetTarget(c99199043.pentg)
	e8:SetOperation(c99199043.penop)
	c:RegisterEffect(e8)
	--tuner related
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(99199043,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1,99199043)
	e9:SetRange(LOCATION_PZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCost(c99199043.pencost)
	e9:SetTarget(c99199043.lvtg)
	e9:SetOperation(c99199043.lvop)
	c:RegisterEffect(e9)
	--ritual summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(99199043,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCountLimit(1,99199043)
	e10:SetCost(c99199043.pencost)
	e10:SetTarget(c99199043.ritualtg)
	e10:SetOperation(c99199043.ritualop)
	c:RegisterEffect(e10)
	--scale
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_LSCALE)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCondition(c99199043.sccon)
	e11:SetValue(4)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e12)
	--destroy
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetCost(c99199043.descost)
	e13:SetTarget(c99199043.destg)
	e13:SetOperation(c99199043.desop)
	c:RegisterEffect(e13)
end
function c99199043.atkval(e,c)
	return Duel.GetMatchingGroupCount(c99199043.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*800
end
function c99199043.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15)
end
function c99199043.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c99199043.splimit1(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199043.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199043.splimit2(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c99199043.mat_filter(c)
	return false
end
function c99199043.ritualsumfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c99199043.ritual_custom_condition(c,mg,ft)
	local tp=c:GetControler()
	local g=mg:Filter(c99199043.ritualsumfilter,c,tp)
	return ft>-3 and g:IsExists(c99199043.ritfilter1,1,nil,c:GetLevel(),g)
end
function c99199043.ritfilter1(c,lv,mg)
	lv=lv-c:GetLevel()
	if lv<2 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsRace,nil,c:GetRace())
	return mg2:IsExists(c99199043.ritfilter2,1,nil,lv,mg2)
end
function c99199043.ritfilter2(c,lv,mg)
	local clv=c:GetLevel()
	lv=lv-clv
	if lv<1 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsRace,nil,c:GetRace())
	return mg2:IsExists(c99199043.ritfilter3,1,nil,lv)
end
function c99199043.ritfilter3(c,lv)
	return c:GetLevel()==lv
end
function c99199043.ritual_custom_operation(c,mg)
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local g=mg:Filter(c99199043.ritualsumfilter,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c99199043.ritfilter1,1,1,nil,lv,g)
	local tc1=g1:GetFirst()
	lv=lv-tc1:GetLevel()
	g:Remove(Card.IsRace,nil,tc1:GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,c99199043.ritfilter2,1,1,nil,lv,g)
	local tc2=g2:GetFirst()
	lv=lv-tc2:GetLevel()
	g:Remove(Card.IsRace,nil,tc2:GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=g:FilterSelect(tp,c99199043.ritfilter3,1,1,nil,lv)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
end
function c99199043.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199043.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199043.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199043.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199043.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199043.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199043.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199043.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199043.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199043.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199043.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199043.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199043.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199043.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199043.tunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c99199043.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199043.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199043.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99199043.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
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
function c99199043.lvop(e,tp,eg,ep,ev,re,r,rp)
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
function c99199043.ritualsumfilter2(c,e,tp,m,ft)
	if not c:IsSetCard(0xff15) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(99199043) then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c99199043.mfilterf,1,nil,tp,mg,c)
	end
end
function c99199043.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c99199043.ritualtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c99199043.ritualsumfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c99199043.ritualop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c99199043.ritualsumfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(99199043) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c99199043.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c99199043.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeckAsCost()
end
function c99199043.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199043.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99199043.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99199043.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c99199043.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99199043.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199043.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99199043.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c99199043.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
