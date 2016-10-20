--Blackwing - Nothung the Starlight
function c512000110.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x33),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000768,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,512000110)
	e1:SetCost(c512000110.cost)
	e1:SetCondition(c512000110.condition)
	e1:SetTarget(c512000110.target)
	e1:SetOperation(c512000110.operation)
	c:RegisterEffect(e1)
	--spsum success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000768,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c512000110.spcon)
	e2:SetTarget(c512000110.sptg)
	e2:SetOperation(c512000110.spop)
	c:RegisterEffect(e2)
end
function c512000110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c512000110.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and c:GetCode()~=95040215
end
function c512000110.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsExistingMatchingCard(c512000110.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c512000110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c512000110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c512000110.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetCountLimit(1)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c512000110.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c512000110.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c512000110.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800) end
end
function c512000110.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-800)
		tc:RegisterEffect(e1)
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
