--Nyx, Shaderune of the Night
function c6666675.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,3)
	c:EnableReviveLimit()
	--shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(6666675,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c6666675.cost)
	e1:SetCondition(c6666675.condition)
	e1:SetTarget(c6666675.target)
	e1:SetOperation(c6666675.operation)
	c:RegisterEffect(e1)
	--Immune to Traps
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c6666675.imcon)
	e2:SetValue(c6666675.efilter)
	c:RegisterEffect(e2)
end
function c6666675.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c6666675.filter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c6666675.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c6666675.filter,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c6666675.shfilter(c)
	return c:IsAbleToDeck() and not c:IsCode(6666675)
end
function c6666675.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c6666675.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c6666675.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c6666675.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c6666675.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c6666675.ofilter(c)
	return c:IsCode(6666670)
end
function c6666675.imcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(c6666675.ofilter,1,nil)
end
function c6666675.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end