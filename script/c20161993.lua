--Lizardfolk - Axer
function c20161993.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20161993,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(c20161993.condition)
	e1:SetTarget(c20161993.target)
	e1:SetOperation(c20161993.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20161993,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,20161993)
	e2:SetCondition(c20161993.sumcon)
	e2:SetCost(c20161993.sumcost)
	e2:SetTarget(c20161993.sumtg)
	e2:SetOperation(c20161993.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end
function c20161993.confilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c20161993.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c20161993.confilter,1,nil)
end
function c20161993.thfilter(c)
	return c:IsSetCard(0xab90) and not c:IsCode(20161993) and c:IsAbleToHand()
end
function c20161993.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20161993.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20161993.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20161993.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20161993.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20161993.cfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c20161993.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20161993.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c20161993.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c20161993.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab90) or c:IsSetCard(0xab91) or c:IsSetCard(0xab92) and c:GetCode()~=92609670 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20161993.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20161993.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c20161993.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20161993.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 and not g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
