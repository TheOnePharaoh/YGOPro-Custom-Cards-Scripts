--The Legendary Ancient Golem - Barakthum
function c66165087.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66165087,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c66165087.descon)
	e2:SetCost(c66165087.descost)
	e2:SetTarget(c66165087.destg)
	e2:SetOperation(c66165087.desop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165087,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c66165087.negcon)
	e3:SetCost(c66165087.negcost)
	e3:SetTarget(c66165087.negtg)
	e3:SetOperation(c66165087.negop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66165087,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c66165087.thcon)
	e4:SetTarget(c66165087.thtg)
	e4:SetOperation(c66165087.thop)
	c:RegisterEffect(e4)
end
function c66165087.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165087.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c66165087.desfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c66165087.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c66165087.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	Duel.SetChainLimit(aux.FALSE)
end
function c66165087.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66165087.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c66165087.negfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c66165087.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c66165087.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c66165087.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c66165087.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c66165087.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c66165087.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165087.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK) and c:IsAbleToHand()
end
function c66165087.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66165087.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66165087.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66165087.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
