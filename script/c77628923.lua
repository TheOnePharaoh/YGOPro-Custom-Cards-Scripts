--Black Art Remnants
function c77628923.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77628923)
	e1:SetCost(c77628923.cost)
	e1:SetTarget(c77628923.target)
	e1:SetOperation(c77628923.activate)
	c:RegisterEffect(e1)
end
function c77628923.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsDiscardable()
end
function c77628923.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628923.filter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c77628923.filter,2,2,REASON_COST+REASON_DISCARD)
end
function c77628923.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c77628923.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
