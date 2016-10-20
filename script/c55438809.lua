--The Mage's Secret Tome
function c55438809.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c55438809.cost)
	e1:SetTarget(c55438809.target)
	e1:SetOperation(c55438809.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55438809,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,55438809)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c55438809.thcost)
	e2:SetTarget(c55438809.thtg)
	e2:SetOperation(c55438809.thop)
	c:RegisterEffect(e2)
end
function c55438809.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,5,nil) end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438809.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c55438809.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c55438809.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c55438809.thfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c55438809.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438809.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55438809.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55438809.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end