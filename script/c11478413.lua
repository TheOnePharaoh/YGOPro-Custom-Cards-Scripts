--War God of the Bound Creator
function c11478413.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11478413.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478413,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,11478413)
	e2:SetCondition(c11478413.condition)
	e2:SetTarget(c11478413.target1)
	e2:SetOperation(c11478413.operation1)
	c:RegisterEffect(e2)
	--search2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478413,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1,11478413)
	e3:SetCondition(c11478413.condition)
	e3:SetTarget(c11478413.target2)
	e3:SetOperation(c11478413.operation2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11478413,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c11478413.negcon)
	e4:SetCost(c11478413.cost)
	e4:SetTarget(c11478413.negtg)
	e4:SetOperation(c11478413.negop)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11478413,3))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetCondition(c11478413.discon)
	e5:SetCost(c11478413.cost)
	e5:SetTarget(c11478413.distg)
	e5:SetOperation(c11478413.disop)
	c:RegisterEffect(e5)
end
function c11478413.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c11478413.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c11478413.filter1(c)
	return c:IsSetCard(0xf2002) and c:IsAbleToHand()
end
function c11478413.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478413.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11478413.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478413.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11478413.filter2(c)
	return c:IsSetCard(0xf2001) and c:IsAbleToHand()
end
function c11478413.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478413.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11478413.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478413.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11478413.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c11478413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11478413.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11478413.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11478413.disfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c11478413.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c11478413.disfilter,1,nil,1-tp)
end
function c11478413.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c11478413.disfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11478413.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c11478413.disfilter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end