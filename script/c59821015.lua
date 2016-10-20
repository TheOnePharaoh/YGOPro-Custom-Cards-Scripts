--Back Attack
function c59821015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c59821015.cost)
	e1:SetTarget(c59821015.target)
	e1:SetOperation(c59821015.activate)
	c:RegisterEffect(e1)
end
function c59821015.cfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsDiscardable()
end
function c59821015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821015.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c59821015.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c59821015.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttackAbove(1500) and c:GetSummonPlayer()==tp and c:IsDestructable() and not c:IsDisabled()
end
function c59821015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c59821015.filter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c59821015.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c59821015.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttackAbove(1500)
		and c:GetSummonPlayer()==tp and c:IsDestructable() and c:IsRelateToEffect(e)
end
function c59821015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c59821015.filter2,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if not tc:IsDisabled() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
