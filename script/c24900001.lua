--Galaxy Summoner
function c24900001.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCondition(c24900001.condition)
e1:SetTarget(c24900001.target)
e1:SetOperation(c24900001.operation)
c:RegisterEffect(e1)
--special summon
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_IGNITION)
e2:SetCountLimit(1,24900001)
e2:SetRange(LOCATION_SZONE)
e2:SetCost(c24900001.coscost)
e2:SetTarget(c24900001.costarget)
e2:SetOperation(c24900001.cosoperation)
c:RegisterEffect(e2)
--immune monster effect
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_SINGLE)
e3:SetCode(EFFECT_IMMUNE_EFFECT)
e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e3:SetRange(LOCATION_SZONE)
e3:SetValue(c24900001.efilter)
c:RegisterEffect(e3)
--to hand
local e4=Effect.CreateEffect(c)
e4:SetCategory(CATEGORY_TOHAND)
e4:SetDescription(aux.Stringid(24900001,0))
e4:SetType(EFFECT_TYPE_IGNITION)
e4:SetCountLimit(1,24900001)
e4:SetRange(LOCATION_GRAVE)
e4:SetCost(c24900001.thcost)
e4:SetTarget(c24900001.thtg)
e4:SetOperation(c24900001.thop)
c:RegisterEffect(e4)
end
function c24900001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and Duel.GetTurnPlayer()==tp
end
function c24900001.actfilter(c)
return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToGrave()
end
function c24900001.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c24900001.actfilter,tp,LOCATION_DECK,0,1,nil) end
Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c24900001.operation(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectMatchingCard(tp,c24900001.actfilter,tp,LOCATION_DECK,0,1,1,nil)
if g:GetCount()>0 then
Duel.SendtoGrave(g,REASON_EFFECT)
end
end
function c24900001.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c24900001.costarget(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
Duel.Hint(HINT_SELECTMSG,tp,564)
if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
local g=Duel.GetDecktopGroup(tp,1)
local tc=g:GetFirst()
math.randomseed( tc:getcode() )
end
i = math.random(20)
ac=math.random(1,18)
e:SetLabel(galaxy_table[ac])
end
function c24900001.overlayfilter(c)
return (not c:IsHasEffect(EFFECT_NECRO_VALLEY)) and (not c:IsType(TYPE_MONSTER))
end
function c24900001.cosoperation(e,tp,eg,ep,ev,re,r,rp)
local created=Duel.CreateToken(tp,e:GetLabel())
Duel.SpecialSummon(created,0,tp,tp,true,false,POS_FACEUP)
if created:IsFaceup() and created:IsType(TYPE_XYZ) then
if Duel.IsExistingMatchingCard(c24900001.overlayfilter,tp,LOCATION_GRAVE,0,1,nil) then
local g=Duel.SelectMatchingCard(tp,c24900001.overlayfilter,tp,LOCATION_GRAVE,0,1,2,nil)
if g:GetCount()>0 then
Duel.Overlay(created,g)
end
end
end
end
galaxy_table={
9024367,
35950025,
98263709,
11066358,
46659709,
24658418,
98555327,
9260791,
39272762,
10389142,
31801517,
48928529,
88177324,
68396121,
66523544,
93717133,
39030163,
58820923
}
function c24900001.efilter(e,te)
return te:IsActiveType(TYPE_EFFECT)
end
function c24900001.thfilter(c)
return c:IsSetCard(0x7B) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c24900001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c24900001.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
local g=Duel.SelectMatchingCard(tp,c24900001.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24900001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsAbleToHand() end
Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24900001.thop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsRelateToEffect(e) then
Duel.SendtoHand(c,nil,REASON_EFFECT)
Duel.ConfirmCards(1-tp,c)
end
end