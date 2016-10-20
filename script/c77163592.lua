--Accel Vocaloid's Spawn
function c77163592.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac405),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c77163592.splimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77163592,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77163592.target)
	e2:SetOperation(c77163592.operation)
	c:RegisterEffect(e2)
	--damage val
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--suicide
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c77163592.descon)
	c:RegisterEffect(e5)
	--Special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77163592,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c77163592.sumcon)
	e6:SetTarget(c77163592.sumtg)
	e6:SetOperation(c77163592.sumop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e9)
end
function c77163592.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_SYNCHRO
end
function c77163592.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402) and not c:IsCode(77163592)
end
function c77163592.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c77163592.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77163592.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77163592.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77163592.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
end
function c77163592.selffilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c77163592.descon(e)
	return not Duel.IsExistingMatchingCard(c77163592.selffilter,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c77163592.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77163592.sumfilter(c,e,tp)
	return c:IsCode(58431891) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77163592.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77163592.sumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77163592.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77163592.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end