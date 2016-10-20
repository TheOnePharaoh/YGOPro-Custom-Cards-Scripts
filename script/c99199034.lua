--The Future Gear Arch Ark the God of Creator
function c99199034.initial_effect(c)
	c:SetUniqueOnField(1,0,99199034)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c99199034.fscon)
	e1:SetOperation(c99199034.fsop)
	c:RegisterEffect(e1)
	--special summon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99199034.tgval)
	c:RegisterEffect(e3)
	--Tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c99199034.rvcost)
	e4:SetTarget(c99199034.rvtg)
	e4:SetOperation(c99199034.rvop)
	c:RegisterEffect(e4)
	--atk modify
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c99199034.atktg)
	e5:SetOperation(c99199034.atkop)
	c:RegisterEffect(e5)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c99199034.splimit)
	e6:SetCondition(c99199034.splimcon)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c99199034.con)
	e7:SetOperation(c99199034.op)
	c:RegisterEffect(e7)
	--place pcard
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(99199034,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,99199034)
	e8:SetCondition(c99199034.pencon)
	e8:SetCost(c99199034.pencost)
	e8:SetTarget(c99199034.pentg)
	e8:SetOperation(c99199034.penop)
	c:RegisterEffect(e8)
	--tuner related
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(99199034,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1,99199034)
	e9:SetRange(LOCATION_PZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCost(c99199034.pencost)
	e9:SetTarget(c99199034.lvtg)
	e9:SetOperation(c99199034.lvop)
	c:RegisterEffect(e9)
	--fusion summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(99199034,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCountLimit(1,99199034)
	e10:SetCost(c99199034.pencost)
	e10:SetTarget(c99199034.fstg2)
	e10:SetOperation(c99199034.fsop2)
	c:RegisterEffect(e10)
	--scale
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_LSCALE)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCondition(c99199034.sccon)
	e11:SetValue(4)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e12)
end
function c99199034.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199034.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199034.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199034.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199034.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199034.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199034.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199034.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199034.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199034.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199034.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199034.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199034.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199034.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199034.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199034.tunfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c99199034.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99199034.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199034.tunfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99199034.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
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
function c99199034.lvop(e,tp,eg,ep,ev,re,r,rp)
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
function c99199034.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if gc then
		local mg=g:Filter(Card.IsSetCard,nil,0xff15)
		mg:AddCard(gc)
		return gc:IsSetCard(0xff15) and mg:GetClassCount(Card.GetRace)>=3
	end
	local fs=false
	local mg=g:Filter(Card.IsSetCard,nil,0xff15)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetRace)>=3 and (fs or chkf==PLAYER_NONE)
end
function c99199034.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsSetCard,gc,0xff15)
		sg:Remove(Card.IsRace,nil,gc:GetRace())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		sg:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(Card.IsSetCard,nil,0xff15)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsRace,nil,g2:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetFusionMaterial(g1)
end
function c99199034.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c99199034.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15) and c:IsAbleToDeckOrExtraAsCost()
end
function c99199034.rvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199034.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c99199034.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoExtraP(g,POS_FACEUP,REASON_COST)
end
function c99199034.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15) and c:IsAbleToHand()
end
function c99199034.rvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c99199034.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199034.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99199034.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99199034.rvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c99199034.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99199034.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c99199034.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c99199034.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xff15) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99199034.fstg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c99199034.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99199034.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99199034.fsop2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c99199034.filter1,tp,LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c99199034.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99199034.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	else
		local cg1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		if cg1:GetCount()>1 and cg2:IsExists(Card.IsFacedown,1,nil)
			and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
			Duel.ConfirmCards(1-tp,cg1)
			Duel.ConfirmCards(1-tp,cg2)
			Duel.ShuffleHand(tp)
		end
	end
end
function c99199034.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end