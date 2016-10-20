--Vocaloid Akita Neru
function c49791445.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49791445,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c49791445.sgcost)
	e2:SetTarget(c49791445.sgtg)
	e2:SetOperation(c49791445.sgop)
	c:RegisterEffect(e2)
end
function c49791445.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c49791445.spfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c49791445.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c49791445.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c49791445.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c49791445.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49791445.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c49791445.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c49791445.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and c:IsAbleToGrave()
end
function c49791445.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c49791445.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c49791445.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c49791445.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end