--Vocaloid Decisive Shot
function c88930002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c88930002.cost)
	e1:SetTarget(c88930002.target)
	e1:SetOperation(c88930002.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88930002,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c88930002.sgcost)
	e2:SetTarget(c88930002.sgtg)
	e2:SetOperation(c88930002.sgop)
	c:RegisterEffect(e2)
end
function c88930002.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function c88930002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88930002.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c88930002.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c88930002.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c88930002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c88930002.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88930002.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c88930002.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c88930002.limit(g:GetFirst()))
end
function c88930002.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c88930002.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c88930002.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c88930002.enfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function c88930002.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c88930002.enfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c88930002.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88930002.enfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end