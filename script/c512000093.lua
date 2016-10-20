--Scrap-Iron Pitfall
function c512000093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c512000093.target)
	e1:SetOperation(c512000093.activate)
	c:RegisterEffect(e1)
end
function c512000093.filter(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsAbleToHand()
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
end
function c512000093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c512000093.filter,1,nil,tp) end
	local g=eg:Filter(c512000093.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c512000093.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:GetSummonPlayer()~=tp and c:IsAbleToHand()
end
function c512000093.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c512000093.filter2,nil,e,tp)
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
