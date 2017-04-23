--Vocaloid Kids United!
function c17930170.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--disable summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(17930170,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e1:SetCondition(c17930170.condition)
	e1:SetCost(c17930170.cost)
	e1:SetTarget(c17930170.target)
	e1:SetOperation(c17930170.operation)
	c:RegisterEffect(e1)
end
function c17930170.filter(c)
	return c:IsType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION)
end
function c17930170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c17930170.filter,1,nil)
end
function c17930170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17930170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c17930170.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c17930170.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c17930170.filter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
