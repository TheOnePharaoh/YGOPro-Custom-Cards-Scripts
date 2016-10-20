--Sudden Ambush
function c22769932.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22769932.condition)
	e1:SetCost(c22769932.cost)
	e1:SetTarget(c22769932.target)
	e1:SetOperation(c22769932.activate)
	c:RegisterEffect(e1)
	--Activate(special summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c22769932.condition1)
	e2:SetCost(c22769932.cost)
	e2:SetTarget(c22769932.target1)
	e2:SetOperation(c22769932.activate1)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22769932,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,22769932)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c22769932.tgcost)
	e3:SetTarget(c22769932.tgtg)
	e3:SetOperation(c22769932.tgop)
	c:RegisterEffect(e3)
end
function c22769932.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c22769932.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c22769932.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22769932.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22769932.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c22769932.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c22769932.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c22769932.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769932.tgfilter(c)
	return c:IsSetCard(0xaa12) and not c:IsCode(22769932) and c:IsAbleToGrave()
end
function c22769932.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769932.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22769932.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769932.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
