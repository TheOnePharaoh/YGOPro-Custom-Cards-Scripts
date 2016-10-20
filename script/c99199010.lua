--The Future Gear Great Spellmaster Erza
function c99199010.initial_effect(c)
	c:SetSPSummonOnce(99199010)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),2,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99199010.splimit)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--atk gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199010,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c99199010.adcon)
	e3:SetOperation(c99199010.adop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c99199010.desreptg)
	c:RegisterEffect(e4)
	--fusion summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199010,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,99199010)
	e5:SetTarget(c99199010.fstg)
	e5:SetOperation(c99199010.fsop)
	c:RegisterEffect(e5)
	--to pzone
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c99199010.con)
	e6:SetOperation(c99199010.op)
	c:RegisterEffect(e6)
	--place pcard
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(99199010,2))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1,99199010)
	e7:SetCondition(c99199010.pencon)
	e7:SetCost(c99199010.pencost)
	e7:SetTarget(c99199010.pentg)
	e7:SetOperation(c99199010.penop)
	c:RegisterEffect(e7)
	--splimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(c99199010.splimit2)
	e8:SetCondition(c99199010.splimcon2)
	c:RegisterEffect(e8)
end
function c99199010.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99199010.adcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c99199010.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c99199010.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c99199010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c99199010.repfilter,tp,LOCATION_EXTRA,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(99199010,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c99199010.repfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
		return true
	else return false end
end
function c99199010.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c99199010.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xff15) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99199010.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c99199010.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99199010.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99199010.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c99199010.filter1,tp,LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c99199010.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99199010.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
function c99199010.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199010.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199010.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199010.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199010.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199010.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199010.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199010.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199010.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199010.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199010.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199010.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199010.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199010.splimit2(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199010.splimcon2(e)
	return not e:GetHandler():IsForbidden()
end