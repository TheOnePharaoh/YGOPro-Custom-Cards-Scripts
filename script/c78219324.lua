--N.A.N.O Machinery Disposal Unit
function c78219324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,78219324)
	e1:SetCost(c78219324.cost)
	e1:SetTarget(c78219324.target)
	e1:SetOperation(c78219324.activate)
	c:RegisterEffect(e1)
end
function c78219324.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c78219324.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219324.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c78219324.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c78219324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c78219324.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
