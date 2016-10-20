--Vocaloid Anri Rune
function c11111138.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111138,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,11111138)
	e1:SetCondition(c11111138.condition)
	e1:SetCost(c11111138.cost)
	e1:SetTarget(c11111138.target)
	e1:SetOperation(c11111138.operation)
	c:RegisterEffect(e1)
	--spsum success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111138,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111138.spcon)
	e2:SetTarget(c11111138.sptg)
	e2:SetOperation(c11111138.spop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c11111138.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c11111138.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11111138.filter(c)
	return c:IsSetCard(0x0dac402) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c11111138.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11111138.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111138.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c11111138.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11111138.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function c11111138.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c11111138.spfilter(c,e,sp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_MACHINE) and c:GetCode()~=11111138 and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c11111138.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111138.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11111138.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11111138.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11111138.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
