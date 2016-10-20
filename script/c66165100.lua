--Golem Un-Summoning
function c66165100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c66165100.cost)
	e1:SetTarget(c66165100.target)
	e1:SetOperation(c66165100.activate)
	c:RegisterEffect(e1)
	--deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66165100,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,66165100)
	e2:SetCondition(c66165100.deckcon)
	e2:SetCost(c66165100.deckcost)
	e2:SetTarget(c66165100.decktg)
	e2:SetOperation(c66165100.deckop)
	c:RegisterEffect(e2)
end
function c66165100.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xea010)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:IsAbleToHandAsCost()
end
function c66165100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66165100.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c66165100.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c66165100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c66165100.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66165100.deckfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetReasonPlayer()~=tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==tp and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c66165100.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66165100.deckfilter,1,nil,tp)
end
function c66165100.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xea010) and not c:IsCode(66165100) and c:IsAbleToRemoveAsCost()
end
function c66165100.deckcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c66165100.costfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66165100.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66165100.decktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c66165100.deckfilter(chkc,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,c66165100.deckfilter,1,1,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66165100.deckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end