--Junior Brunette
function c160004692.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160004692,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c160004692.spcost)
	e1:SetTarget(c160004692.sptg)
	e1:SetOperation(c160004692.spop)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c160004692.efilter)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160004692,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c160004692.thcon)
	e4:SetTarget(c160004692.thtg)
	e4:SetOperation(c160004692.thop)
	c:RegisterEffect(e4)
end
function c160004692.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c160004692.filter(c,e,tp)
	return c:IsSetCard(0x89b) and c:GetCode()~=160004692 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160004692.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c160004692.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c160004692.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160004692.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c160004692.filterx(c,e,tp)
	return c:IsSetCard(0x89b) and c:GetCode()~=160004692 and c:IsAbleToHand()
end
function c160004692.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c160004692.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160004692.filterx,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c160004692.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160004692.filterx,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c160004692.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
