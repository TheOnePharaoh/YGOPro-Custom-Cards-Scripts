--White Sign Soapstone
--lua script by SGJin
function c12310739.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12310739+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12310739.cost)
	e1:SetTarget(c12310739.target)
	e1:SetOperation(c12310739.activate)
	c:RegisterEffect(e1)
end
function c12310739.cfilter(c)
	return c:IsCode(12310712) and c:IsAbleToDeckAsCost()
end
function c12310739.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310739.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12310739.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12310739.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310739.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12310739.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c12310739.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12310739.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
