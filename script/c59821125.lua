--The Idol's Legacy
function c59821125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c59821125.target)
	e1:SetOperation(c59821125.activate)
	c:RegisterEffect(e1)
	--destroy&draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821125,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821125+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c59821125.descost)
	e2:SetTarget(c59821125.destg)
	e2:SetOperation(c59821125.desop)
	c:RegisterEffect(e2)
end
function c59821125.tgfilter(c,tp)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c59821125.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c59821125.thfilter(c,code)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and not c:IsCode(code) and c:IsAbleToHand()
end
function c59821125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821125.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821125.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c59821125.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c59821125.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c59821125.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c59821125.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c59821125.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821125.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59821125.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c59821125.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821125.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end