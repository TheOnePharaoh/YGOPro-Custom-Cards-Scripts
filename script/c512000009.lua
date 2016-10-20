--Subspatial Battle
function c512000009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--use effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(512000009,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c512000009.target)
	e1:SetOperation(c512000009.operation)
	c:RegisterEffect(e1)
end
function c512000009.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c512000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000009.filter,tp,LOCATION_DECK,0,3,nil) and Duel.IsExistingMatchingCard(c512000009.filter,tp,0,LOCATION_DECK,3,nil) end
end
function c512000009.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c512000009.filter,tp,LOCATION_DECK,0,3,nil) or not Duel.IsExistingMatchingCard(c512000009.filter,tp,0,LOCATION_DECK,3,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,1))
	local g1=Duel.SelectMatchingCard(tp,c512000009.filter,tp,LOCATION_DECK,0,3,3,nil)
	if g1:GetCount()<3 then return end
	local g2=Duel.SelectMatchingCard(1-tp,c512000009.filter,tp,0,LOCATION_DECK,3,3,nil)
	if g2:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	local sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
	g1:Sub(sg1)
	g2:Sub(sg2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
	g1:Sub(sg1)
	g2:Sub(sg2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(512000009,2))
	sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
