--D.S. Sea Dragon
function c29001792.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FISH),1)
	c:EnableReviveLimit()
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29001792,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29001792.poscon)
	e1:SetTarget(c29001792.postg)
	e1:SetOperation(c29001792.posop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29001792,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29001792.spcon)
	e2:SetCost(c29001792.spcost)
	e2:SetTarget(c29001792.sptg)
	e2:SetOperation(c29001792.spop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c29001792.spcon)
	c:RegisterEffect(e3)
end
function c29001792.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c29001792.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsCode(29001792)
end
function c29001792.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c29001792.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29001792.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c29001792.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c29001792.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c29001792.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c29001792.spcon(e)
	return Duel.IsExistingMatchingCard(c29001792.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c29001792.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c29001792.specfilter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:GetCode()~=29001792
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c29001792.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29001792.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c29001792.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29001792.specfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
