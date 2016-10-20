--Vadise, High Ruler of the Bound Creator
function c11478411.initial_effect(c)
	c:SetUniqueOnField(1,0,11478411)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsCode,11478402),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DEVINE))
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11478411,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c11478411.tdtg)
	e2:SetOperation(c11478411.tdop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11478411,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c11478411.cost)
	e3:SetTarget(c11478411.target)
	e3:SetOperation(c11478411.operation)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c11478411.sumlimit)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c11478411.efffilter)
	c:RegisterEffect(e5)
end
function c11478411.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c11478411.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(g:GetCount()*800)
		c:RegisterEffect(e1)
	end
end
function c11478411.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c11478411.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478411.costfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,c11478411.costfilter,2,2,REASON_COST+REASON_DISCARD)
end
function c11478411.thfilter(c)
	return c:IsCode(269012) and c:IsAbleToHand()
end
function c11478411.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11478411.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11478411.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11478411.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11478411.efffilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c11478411.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_HAND) and not c:IsType(TYPE_RITUAL)
end