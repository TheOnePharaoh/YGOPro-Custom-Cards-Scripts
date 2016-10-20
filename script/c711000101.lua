--セイヴァー・スター・ドラゴン
function c711000101.initial_effect(c)
	c:SetUniqueOnField(1,1,711000101)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c711000101.syncon)
	e1:SetOperation(c711000101.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(711000101,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c711000101.negcon)
	e2:SetCost(c711000101.negcost)
	e2:SetTarget(c711000101.negtg)
	e2:SetOperation(c711000101.negop)
	c:RegisterEffect(e2)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(711000101,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c711000101.sumtg)
	e3:SetOperation(c711000101.sumop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(711000101,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c711000101.spcon)
	e4:SetTarget(c711000101.sptg)
	e4:SetOperation(c711000101.spop)
	c:RegisterEffect(e4)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
end
function c711000101.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c711000101.synfilter1(c,lv,g)
	if not c:IsCode(21159309) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	local t=false
	if c:IsType(TYPE_TUNER) then t=true end
	local wg=g:Clone()
	wg:RemoveCard(c)
	return wg:IsExists(c711000101.synfilter2,1,nil,lv-tlv,wg,t)
end
function c711000101.synfilter2(c,lv,g,tuner)
	if not c:IsCode(44508094) then return false end
	local tlv=c:GetLevel()
	if lv-tlv<=0 then return false end
	if not tuner and not c:IsType(TYPE_TUNER) then return false end
	return g:IsExists(c711000101.synfilter3,1,c,lv-tlv)
end
function c711000101.synfilter3(c,lv)
	return c:IsNotTuner() and c:GetLevel()==lv
end
function c711000101.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c711000101.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c711000101.synfilter1(tuner,lv,mg) end
	return mg:IsExists(c711000101.synfilter1,1,nil,lv,mg)
end
function c711000101.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c711000101.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c711000101.synfilter1,1,1,nil,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	lv=lv-m1:GetLevel()
	local t=false
	if m1:IsType(TYPE_TUNER) then t=true end
	mg:RemoveCard(m1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c711000101.synfilter2,1,1,nil,lv,mg,t)
	local m2=t2:GetFirst()
	g:AddCard(m2)
	lv=lv-m2:GetLevel()
	mg:RemoveCard(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t3=mg:FilterSelect(tp,c711000101.synfilter3,1,1,nil,lv)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c711000101.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c711000101.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(711000101)==0 or e:GetHandler():IsReleasable() end
	if e:GetHandler():GetFlagEffect(711000101)==0 then
		e:GetHandler():RegisterFlagEffect(711000101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
	end
end
function c711000101.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c711000101.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(711000101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c711000101.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(711000101)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c711000101.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end
function c711000101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c711000101.spfilter(c,e,tp)
	return c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c711000101.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c711000101.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c711000101.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c711000101.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c711000101.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
