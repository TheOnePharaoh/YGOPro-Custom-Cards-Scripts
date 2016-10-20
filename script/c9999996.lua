--Destroto
function c9999996.initial_effect(c)
	c:SetUniqueOnField(1,0,9999996)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c9999996.syncon)
	e3:SetOperation(c9999996.synop)
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c9999996.sumsuc)
	c:RegisterEffect(e4)
	--unaffected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c9999996.efilter)
	c:RegisterEffect(e5)
	--sp summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9999996,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c9999996.spcost)
	e6:SetTarget(c9999996.sptg1)
	e6:SetOperation(c9999996.spop)
	c:RegisterEffect(e6)
	--Cannot be leave
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetCondition(c9999996.leavecon)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e10)
	local e11=e8:Clone()
	e11:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e11)
	local e12=e8:Clone()
	e12:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e12)
	local e13=e8:Clone()
	e13:SetCode(EFFECT_CANNOT_TO_EXTRA)
	c:RegisterEffect(e13)
	--Cannot be Material
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e15)
	local e16=e14:Clone()
	e16:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e16)
	--cannot release
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCode(EFFECT_UNRELEASABLE_SUM)
	e17:SetValue(1)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e18)
end
function c9999996.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c9999996.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c9999996.matfilter2(c,syncard)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial(syncard)
end
function c9999996.synfilter1(c,syncard,lv,g1,g2,g3)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	if c:IsHasEffect(55863245) then
		return g3:IsExists(c9999996.synfilter2,1,c,syncard,lv-tlv,g2,f1,c)
	else
		return g1:IsExists(c9999996.synfilter2,1,c,syncard,lv-tlv,g2,f1,c)
	end
end
function c9999996.synfilter2(c,syncard,lv,g2,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	return g2:IsExists(c9999996.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
end
function c9999996.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c9999996.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c9999996.matfilter1,nil,c)
		g2=mg:Filter(c9999996.matfilter2,nil,c)
		g3=mg:Filter(c9999996.matfilter1,nil,c)
	else
		g1=Duel.GetMatchingGroup(c9999996.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c9999996.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c9999996.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c9999996.synfilter2,1,tuner,c,lv-tlv,g2,f1,tuner)
		else
			return c9999996.synfilter2(pe:GetOwner(),c,lv-tlv,g2,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c9999996.synfilter1,1,nil,c,lv,g1,g2,g3)
	else
		return c9999996.synfilter1(pe:GetOwner(),c,lv,g1,g2)
	end
end
function c9999996.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c9999996.matfilter1,nil,c)
		g2=mg:Filter(c9999996.matfilter2,nil,c)
		g3=mg:Filter(c9999996.matfilter1,nil,c)
	else
		g1=Duel.GetMatchingGroup(c9999996.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c9999996.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c9999996.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c9999996.synfilter2,1,1,tuner,c,lv-lv1,g2,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c9999996.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c9999996.synfilter1,1,1,nil,c,lv,g1,g2,g3)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		local t2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(55863245) then
			t2=g3:FilterSelect(tp,c9999996.synfilter2,1,1,tuner1,c,lv-lv1,g2,f1,tuner1)
		else
			t2=g1:FilterSelect(tp,c9999996.synfilter2,1,1,tuner1,c,lv-lv1,g2,f1,tuner1)
		end
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c9999996.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c9999996.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_SYNCHRO then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c9999996.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9999996.spcostfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c9999996.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9999996.spcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9999996.spcostfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9999996.spfilter(c,e,tp)
	return not c:IsCode(9999997) and not c:IsCode(9999996)
		and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) 
end
function c9999996.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c9999996.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9999996.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e,tp) end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9999996.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9999996.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_SYNCHRO) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c9999996.ftarget)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		tc:CompleteProcedure()
	end
end
function c9999996.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c9999996.leavefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9999996.leavecon(e)
	return Duel.IsExistingMatchingCard(c9999996.leavefilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
