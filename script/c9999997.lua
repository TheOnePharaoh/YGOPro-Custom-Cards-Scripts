--Odelschwanck
function c9999997.initial_effect(c)
	c:SetUniqueOnField(1,0,9999997)
	c:EnableReviveLimit()
	--xyzsummon condition
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
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c9999997.xyzcon)
	e3:SetOperation(c9999997.xyzop)
	e3:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c9999997.sumsuc)
	c:RegisterEffect(e4)
	--unaffected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c9999997.efilter)
	c:RegisterEffect(e5)
	--sp summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9999997,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,9999997)
	e6:SetCost(c9999997.cost)
	e6:SetTarget(c9999997.sptg1)
	e6:SetOperation(c9999997.spop)
	c:RegisterEffect(e6)
	--material
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9999997,3))
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,9999997)
	e8:SetCost(c9999997.xmcost)
	e8:SetCondition(c9999997.xmcon)
	e8:SetTarget(c9999997.xmtg)
	e8:SetOperation(c9999997.xmop)
	c:RegisterEffect(e8)
	--atk/def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(c9999997.atkval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e10)
	--Cannot be Material
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e13)
	--cannot release
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_UNRELEASABLE_SUM)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e15)
	--material
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(9999997,3))
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCountLimit(1,9999997)
	e16:SetCost(c9999997.xmcost)
	e16:SetCondition(c9999997.xmcon)
	e16:SetTarget(c9999997.xmtg)
	e16:SetOperation(c9999997.xmop)
	c:RegisterEffect(e16)
end
function c9999997.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c9999997.mfilter(c)
	local rk=c:GetRank()
	return rk>7 and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9999997.xyzfilter1(c,g)
	return g:IsExists(c9999997.xyzfilter2,3,c,c:GetRank())
end
function c9999997.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c9999997.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c9999997.mfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:IsExists(c9999997.xyzfilter1,1,nil,mg)
end
function c9999997.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c9999997.mfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c9999997.xyzfilter1,4,4,nil,mg)
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	local tc3=g1:GetNext()
	local tc4=g1:GetNext()
	g1:Merge(g1)
	local sg1=tc1:GetOverlayGroup()
	local sg2=tc2:GetOverlayGroup()
	local sg3=tc3:GetOverlayGroup()
	local sg4=tc4:GetOverlayGroup()
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	sg1:Merge(sg4)
	Duel.SendtoGrave(sg1,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c9999997.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_XYZ then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c9999997.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetAttackAnnouncedCount()==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(9999997,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c9999997.spfilter(c,e,tp)
	return not c:IsCode(9999997)
		and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c9999997.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c9999997.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9999997.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil,e,tp) end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9999997.spfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9999997.xfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and not c:IsCode(9999996) and not c:IsCode(9999997)
end
function c9999997.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local g2=Duel.GetMatchingGroup(c9999997.xfilter,tp,LOCATION_HAND,0,nil,e)
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) then
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9999997,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g2:Select(tp,2,2,nil,nil,2)
			if sg:GetCount()>0 then
				tc:SetMaterial(sg)
				Duel.Overlay(tc,sg)
			end
		end
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9999997.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9999997.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c9999997.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0
end
function c9999997.xmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c9999997.xmfilter(c)
	return c:IsType(TYPE_XYZ) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9999997.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9999997.xmfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c9999997.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9999997.xmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
