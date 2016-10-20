--Awakening the Nightmare
function c77628929.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77628929.condition)
	e1:SetTarget(c77628929.target)
	e1:SetOperation(c77628929.activate)
	c:RegisterEffect(e1)
end
function c77628929.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba003)
end
function c77628929.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628929.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628929.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77628929.grafilter,tp,LOCATION_GRAVE,0,4,nil)
end
function c77628929.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77628929.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77628929.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77628929.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77628929.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77628929.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
