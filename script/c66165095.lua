--The Legendary Moss Golem
function c66165095.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165095,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,66165095)
	e1:SetCondition(c66165095.thcon)
	e1:SetTarget(c66165095.thtg)
	e1:SetOperation(c66165095.thop)
	c:RegisterEffect(e1)
	--sort
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c66165095.atkcon)
	e2:SetCost(c66165095.atkcost)
	e2:SetTarget(c66165095.atktg)
	e2:SetOperation(c66165095.atkop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c66165095.dracon)
	e3:SetTarget(c66165095.dratg)
	e3:SetOperation(c66165095.draop)
	c:RegisterEffect(e3)
end
function c66165095.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165095.thfilter(c)
	return c:IsSetCard(0xea010) and not c:IsCode(66165095) and c:IsAbleToHand()
end
function c66165095.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c66165095.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c66165095.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66165095.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c66165095.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c66165095.indtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c66165095.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c66165095.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c66165095.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c66165095.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	if tc:IsSetCard(0xea010) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		local at=Duel.GetAttacker()
		if at:IsFaceup() and at:IsRelateToBattle() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			at:RegisterEffect(e1)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end
function c66165095.dracon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165095.drafilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c66165095.dratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetMatchingGroupCount(c66165095.drafilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c66165095.draop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c66165095.drafilter,p,LOCATION_MZONE,0,nil)+1
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
