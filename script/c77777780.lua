--Hellformed Corruption
function c77777780.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77777780,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c77777780.cost)
	e3:SetCountLimit(1,77777780)
	e3:SetTarget(c77777780.target)
	e3:SetOperation(c77777780.operation)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777780,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c77777780.cost)
	e4:SetCountLimit(1,77777780)
	e4:SetTarget(c77777780.sstg)
	e4:SetOperation(c77777780.ssop)
	c:RegisterEffect(e4)
end

function c77777780.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c77777780.cfilter1,tp,LOCATION_MZONE,0,1,nil) 
		or Duel.IsExistingMatchingCard(c77777780.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)) end
	local op=0
	if Duel.IsExistingMatchingCard(c77777780.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)then op = op+1 end
	if Duel.IsExistingMatchingCard(c77777780.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)then op = op+2 end
	if op==3 then 
		op=Duel.SelectOption(tp,aux.Stringid(77777780,0),aux.Stringid(77777780,1))+1
	end
	if op==1 then
		local g=Duel.SelectMatchingCard(tp,c77777780.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
	if op==2 then
		local g=Duel.SelectMatchingCard(tp,c77777780.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_COST)
	end
end
--[[function c77777780.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777780.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c77777780.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end]]--
function c77777780.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c77777780.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777780.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777780.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77777780.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777780.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77777780.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777780.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c77777780.cfilter1(c)
	return c:IsSetCard(0x3e7)  and c:IsReleasable()
end
function c77777780.cfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDestructable()
end

function c77777780.filter(c)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c77777780.ssfilter(c,e,tp)
	return c:IsSetCard(0x3e7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end