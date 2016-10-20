--God Slaying Machine - Song of Global Possession
function c66652235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,66652235)
	e1:SetCondition(c66652235.condition)
	e1:SetTarget(c66652235.target)
	e1:SetOperation(c66652235.activate)
	c:RegisterEffect(e1)
end
function c66652235.cfilter(c)
	return c:IsFaceup() and c:IsCode(66652236) or c:IsCode(66652237) or c:IsCode(66652238) or c:IsCode(66652239) or c:IsCode(66652240) or c:IsCode(66652241) or c:IsCode(66652242) or c:IsCode(66652243) or c:IsCode(66652244) or c:IsCode(66652245) or c:IsCode(66652246)
end
function c66652235.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66652235.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66652235.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonPlayer()~=tp
		and c:IsDestructable() and c:IsAbleToRemove()
end
function c66652235.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c66652235.filter,1,nil,tp) end
	local g=eg:Filter(c66652235.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c66652235.filter2(c,e,tp)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
end
function c66652235.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c66652235.filter2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
