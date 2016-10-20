--Impervious Time Capsule
function c999100.initial_effect(c)
	c:SetUniqueOnField(1,0,999100)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999100.cost)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999100,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,999100)
	e2:SetCondition(c999100.rmcon)
	e2:SetCost(c999100.cost1)
	e2:SetTarget(c999100.rmtg)
	e2:SetOperation(c999100.rmop)
	c:RegisterEffect(e2)
	--salvate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999100,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c999100.condition)
	e3:SetCost(c999100.cost2)
	e3:SetTarget(c999100.tg)
	e3:SetOperation(c999100.op)
	c:RegisterEffect(e3)
end
function c999100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c999100.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c999100.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c999100.rmfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c999100.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_DECK and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c999100.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c999100.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c999100.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c999100.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_REMOVED,0,4,nil,TYPE_MONSTER)
end
function c999100.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.CheckReleaseGroup(tp,nil,1,nil) 
	and Duel.CheckLPCost(tp,2000) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.PayLPCost(tp,2000)
end
function c999100.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c999100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999100.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c999100.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999100.filter,tp,LOCATION_REMOVED,0,1,5,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
