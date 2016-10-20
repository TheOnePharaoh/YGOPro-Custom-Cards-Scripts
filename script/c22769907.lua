--Dreadnought Mark - 007 Longbow
function c22769907.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769907,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,22769907)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c22769907.condition)
	e1:SetTarget(c22769907.target)
	e1:SetOperation(c22769907.operation)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c22769907.thcon)
	e3:SetTarget(c22769907.thtg)
	e3:SetOperation(c22769907.thop)
	c:RegisterEffect(e3)
end
function c22769907.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsCode(22769907)
end
function c22769907.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22769907.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22769907.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769907.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769907.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaa12) and c:GetLevel()==10
end
function c22769907.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22769907.thfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c22769907.revfilter(c)
	return c:IsSetCard(0xaa12) and not c:IsCode(22769907) and c:IsAbleToHand()
end
function c22769907.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(c22769907.revfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c22769907.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22769907.revfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end