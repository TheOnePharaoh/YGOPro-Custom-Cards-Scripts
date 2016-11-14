function c494476199.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c494476199.target)
	e1:SetOperation(c494476199.activate)
	c:RegisterEffect(e1)
end
function c494476199.filter1(c)
	return c:IsSetCard(0x600) and c:IsLocation(LOCATION_GRAVE)
end
function c494476199.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetTargetPlayer(tp)
end
function c494476199.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local dc=og:FilterCount(c494476199.filter1,nil)			
		if dc>0	then
			Duel.BreakEffect()
			Duel.Draw(p,dc,REASON_EFFECT)
		end
	end
end
