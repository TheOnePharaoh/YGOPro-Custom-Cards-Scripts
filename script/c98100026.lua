--Box Room - Song of Suicidal Memories and a Last Word
function c98100026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c98100026.condition)
	e1:SetTarget(c98100026.target)
	e1:SetOperation(c98100026.operation)
	c:RegisterEffect(e1)
end
function c98100026.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c98100026.eqqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c98100026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c98100026.eqqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c98100026.eqqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98100026.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetCountLimit(1,98100026)
		e3:SetCondition(c98100026.spcon)
		e3:SetCost(c98100026.spcost)
		e3:SetTarget(c98100026.sptg)
		e3:SetOperation(c98100026.spop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end
function c98100026.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c98100026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabelObject(e:GetHandler():GetEquipTarget())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98100026.spfilter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98100026.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c98100026.spfilter2(c,e,tp,code)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98100026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget():IsDestructable()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98100026.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local ec=e:GetLabelObject()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c98100026.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if ec:IsRelateToEffect(e) and ec:IsFaceup() and Duel.Destroy(ec,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c98100026.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c98100026.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(98100026,RESET_EVENT+0x1fe0000,0,1,fid)
		tc2:RegisterFlagEffect(98100026,RESET_EVENT+0x1fe0000,0,1,fid)
		Duel.SpecialSummonComplete()
		g1:Merge(g2)
		g1:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g1)
		e1:SetCondition(c98100026.descon)
		e1:SetOperation(c98100026.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98100026.desfilter(c,fid)
	return c:GetFlagEffectLabel(98100026)==fid
end
function c98100026.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c98100026.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c98100026.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c75361204.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
