--Delayed modification
function c44646227.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c44646227.cost)
	e1:SetTarget(c44646227.target)
	e1:SetOperation(c44646227.activate)
	c:RegisterEffect(e1)
end
function c44646227.filter(c)
	return c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(44646228) and c:IsAbleToDeck()
end
function c44646227.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44646227.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44646227.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c44646227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,500)
end
function c44646227.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Recover(1-tp,500,REASON_EFFECT)
	end
end
