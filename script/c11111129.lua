--Blow Them Away!!!
function c11111129.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c11111129.condition)
	e1:SetTarget(c11111129.target)
	e1:SetOperation(c11111129.activate)
	c:RegisterEffect(e1)
end
function c11111129.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x0dac401)
end
function c11111129.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11111129.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11111129.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c11111129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111129.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c11111129.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c11111129.chlimit)
end
function c11111129.chlimit(e,ep,tp)
	return tp==ep
end
function c11111129.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11111129.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end