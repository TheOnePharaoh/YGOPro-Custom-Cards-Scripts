--Emissary of the Red Dragon
function c999907.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c999907.sfilter,aux.NonTuner(Card.IsSetCard,0x1045),1)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999907,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999907.negcon)
	e1:SetCost(c999907.negcost)
	e1:SetTarget(c999907.negtg)
	e1:SetOperation(c999907.negop)
	c:RegisterEffect(e1)
	--Revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999907,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c999907.sumtg)
	e2:SetOperation(c999907.sumop)
	c:RegisterEffect(e2)
	--Special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999907,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c999907.spcon)
	e3:SetTarget(c999907.sptg)
	e3:SetOperation(c999907.spop)
	c:RegisterEffect(e3)
end
function c999907.sfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c999907.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c999907.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c999907.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999907.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(999907,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c999907.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(999907)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c999907.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c999907.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c999907.spfilter(c,e,tp)
	return c:IsSetCard(0x1045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999907.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999907.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c999907.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999907.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c999907.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
