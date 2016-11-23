--Moon's Broken Dream
function c4242568.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242568,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c4242568.cost)
	e1:SetTarget(c4242568.target)
	e1:SetOperation(c4242568.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(4242568,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4242568)
	e2:SetTarget(c4242568.tdtg)
	e2:SetOperation(c4242568.tdop)
	c:RegisterEffect(e2)
end
function c4242568.costfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c4242568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242568.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,nil) end
	local g1=Duel.GetMatchingGroup(c4242568.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,c4242568.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,nil)
	if g2:GetCount()>0 then
		Duel.Destroy(g2,REASON_EFFECT)
	end
end
function c4242568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c4242568.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c4242568.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4242568.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
