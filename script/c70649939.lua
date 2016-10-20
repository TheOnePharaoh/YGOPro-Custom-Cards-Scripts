--Dragon Exchange
function c70649939.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,70649939)
	e1:SetCost(c70649939.cost)
	e1:SetTarget(c70649939.target)
	e1:SetOperation(c70649939.activate)
	c:RegisterEffect(e1)
end
function c70649939.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsSetCard(0xd0a214) and c:IsAttackBelow(1500) and c:IsDiscardable()
end
function c70649939.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70649939.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c70649939.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c70649939.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c70649939.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
