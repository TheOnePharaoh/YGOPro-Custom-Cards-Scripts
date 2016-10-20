--Garbage Dragon
function c344000008.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c344000008.spcon)
	e1:SetOperation(c344000008.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(344000008,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c344000008.condition)
	e2:SetTarget(c344000008.target)
	e2:SetOperation(c344000008.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end
function c344000008.spfilter(c)
	return (c:IsSetCard(0x444) or c:IsCode(44682448) or c:IsCode(18698739)) and c:IsAbleToRemoveAsCost()
end
function c344000008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c344000008.spfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c344000008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c344000008.spfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c344000008.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c344000008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c344000008.filter(c)
	return (c:IsSetCard(0x444) or c:IsCode(44682448) or c:IsCode(18698739)) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c344000008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c344000008.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
	end
end
