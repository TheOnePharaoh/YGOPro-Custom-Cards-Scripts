--Vocaloid Treason Discharge
function c27886785.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27886785)
	e1:SetCondition(c27886785.condition)
	e1:SetCost(c27886785.cost)
	e1:SetTarget(c27886785.target)
	e1:SetOperation(c27886785.activate)
	c:RegisterEffect(e1)
end
function c27886785.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ)
end
function c27886785.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27886785.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c27886785.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c27886785.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c27886785.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27886785.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c27886785.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27886785.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27886785.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end