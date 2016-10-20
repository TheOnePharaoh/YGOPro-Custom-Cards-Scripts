--Ultimate
function c9999998.initial_effect(c)
	c:SetUniqueOnField(1,0,9999998)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,79856792,89631139,false,false)
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
	e3:SetCondition(c9999998.sprcon)
	e3:SetOperation(c9999998.sprop)
	e3:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c9999998.sumsuc)
	c:RegisterEffect(e4)
	--unaffected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c9999998.efilter)
	c:RegisterEffect(e5)
	--oppextra
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9999998,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,9999998)
	e6:SetCost(c9999998.spcost)
	e6:SetTarget(c9999998.sptg1)
	e6:SetOperation(c9999998.spop)
	c:RegisterEffect(e6)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetOperation(c9999998.atkop)
	c:RegisterEffect(e13)
	--def
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	e14:SetOperation(c9999998.defop)
	c:RegisterEffect(e14)
	--spsummon fusion materials
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(9999998,4))
	e15:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e15:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e15:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e15:SetCode(EVENT_TO_GRAVE)
	e15:SetCondition(c9999998.fmcon)
	e15:SetTarget(c9999998.fmtg)
	e15:SetOperation(c9999998.fmop)
	c:RegisterEffect(e15)
end
function c9999998.sprfilter1(c)
	return c:IsCode(79856792) and c:IsCanBeFusionMaterial()
end
function c9999998.sprfilter2(c)
	return c:IsCode(89631139) and c:IsCanBeFusionMaterial()
end
function c9999998.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c9999998.sprfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9999998.sprfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c9999998.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c9999998.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c9999998.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_FUSION)
end
function c9999998.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_FUSION then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c9999998.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9999998.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c9999998.spfilter(c,e,tp)
	return not c:IsCode(9999997) and not c:IsCode(9999996) and not c:IsCode(9999998) and c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) 
end
function c9999998.ffilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and not c:IsCode(9999997) and not c:IsCode(9999996) and not c:IsCode(9999998)
end
function c9999998.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c9999998.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9999998.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e,tp) end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9999998.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9999998.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local g2=Duel.GetMatchingGroup(c9999998.ffilter,tp,LOCATION_HAND,0,nil,e)
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_FUSION) then
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9999998,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=g2:Select(tp,1,3,nil,nil,3)
			tc:SetMaterial(sg)
			Duel.SendtoGrave(sg,sg)
		end
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9999998.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local s=0
	local tc=g:GetFirst()
	while tc do
		local a=tc:GetAttack()
		if a<0 then a=0 end
		s=s+a
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(s)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c9999998.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local s=0
	local tc=g:GetFirst()
	while tc do
		local a=tc:GetDefense()
		if a<0 then a=0 end
		s=s+a
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetValue(s)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c9999998.fmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9999998.fmfilter(c,e,tp,fusc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9999998.fmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return c:GetSummonType()==SUMMON_TYPE_FUSION
		and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and mg:FilterCount(c9999998.fmfilter,nil,e,tp,c)==ct end
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)
end
function c9999998.fmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroup(c9999998.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<mg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end