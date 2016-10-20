--Dark Android Tedyou
function c99200181.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99200181,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99200181.condition)
	e1:SetCost(c99200181.cost)
	e1:SetTarget(c99200181.target)
	e1:SetOperation(c99200181.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c99200181.efilter)
	c:RegisterEffect(e2)
end
function c99200181.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetOwner():IsType(TYPE_TRAP)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c99200181.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99200181.specfilter(c,e,tp)
	return c:IsCode(99200181) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99200181.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99200181.specfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99200181.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c99200181.specfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	tc=g:GetNext()
	if ft>1 and tc and Duel.SelectYesNo(tp,aux.Stringid(99200181,1)) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c99200181.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
