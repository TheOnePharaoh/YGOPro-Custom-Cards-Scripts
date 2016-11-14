function c494476160.initial_effect(c)
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_TOGRAVE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCost(c494476160.cost)
e1:SetTarget(c494476160.target)
e1:SetOperation(c494476160.activate)
c:RegisterEffect(e1)
end

function c494476160.costfilter(c)
return c:IsSetCard(0x0600) and c:IsDiscardable()
end

function c494476160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c494476160.costfilter,tp,LOCATION_HAND,0,1,nil) end
Duel.DiscardHand(tp,c494476160.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end

function c494476160.dscfilter(c)
return c:IsSetCard(0x0600) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function c494476160.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c494476160.dscfilter,tp,LOCATION_DECK,0,2,nil) end
Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end

function c494476160.activate(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectMatchingCard(tp,c494476160.dscfilter,tp,LOCATION_DECK,0,2,2,nil)
if g:GetCount()>0 then
Duel.SendtoGrave(g,REASON_EFFECT)
end
end

