--Fateful Confrontation
function c19007854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c19007854.aclimit)
	c:RegisterEffect(e2)
	--atk & def down
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e3:SetCountLimit(1)
	e3:SetCondition(c19007854.atkcon)
	e3:SetCost(c19007854.atkcost)
	e3:SetTarget(c19007854.atktg)
	e3:SetOperation(c19007854.atkop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(19007854,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c19007854.spcon)
	e4:SetTarget(c19007854.sptg)
	e4:SetOperation(c19007854.spop)
	c:RegisterEffect(e4)
end
function c19007854.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c19007854.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c19007854.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158) and c:IsAbleToDeckAsCost()
end
function c19007854.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19007854.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c19007854.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c19007854.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c19007854.atkop(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	local atk=cc:GetAttack()
	local def=cc:GetDefense()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-def)
		tc:RegisterEffect(e2)
	end
end
function c19007854.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c19007854.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007854.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c19007854.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c19007854.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c19007854.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c19007854.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
