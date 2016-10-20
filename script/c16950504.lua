--Tuner's Elimination
function c16950504.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c16950504.condition)
	e1:SetTarget(c16950504.target)
	e1:SetOperation(c16950504.activate)
	c:RegisterEffect(e1)
end
function c16950504.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetSummonType()==SUMMON_TYPE_SYNCHRO and ep~=tp
end
function c16950504.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove()
end
function c16950504.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16950504.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c16950504.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c16950504.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c16950504.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end
