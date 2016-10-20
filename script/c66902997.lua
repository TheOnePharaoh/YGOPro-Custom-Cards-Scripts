--Rebirth of The Legendary Vocaloid
function c66902997.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66902997)
	e1:SetTarget(c66902997.target)
	e1:SetOperation(c66902997.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66902997,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c66902997.thcost)
	e2:SetTarget(c66902997.thtg)
	e2:SetOperation(c66902997.thop)
	c:RegisterEffect(e2)
end
function c66902997.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x0dac401)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c66902997.matfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function c66902997.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c66902997.matfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c66902997.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c66902997.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c66902997.matfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c66902997.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c66902997.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66902997.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac401) and c:IsAbleToHand()
end
function c66902997.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66902997.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66902997.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66902997.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
