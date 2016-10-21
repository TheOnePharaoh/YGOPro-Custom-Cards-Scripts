--DAL - Arusu Maria
function c99970900.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970900,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1)
  e1:SetCondition(c99970900.spcon)
  e1:SetOperation(c99970900.spop)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970900,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,99970900)
  e2:SetCost(c99970900.thcost)
  e2:SetTarget(c99970900.thtg)
  e2:SetOperation(c99970900.thop)
  c:RegisterEffect(e2)
  --Draw
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DECKDES)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(c99970900.drcon)
  e3:SetTarget(c99970900.drtg)
  e3:SetOperation(c99970900.drop)
  c:RegisterEffect(e3)
end
function c99970900.spfilter(c)
  return c:IsSetCard(9997) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c99970900.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
   and Duel.IsExistingMatchingCard(c99970900.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c99970900.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c99970900.spfilter,tp,LOCATION_HAND,0,1,1,nil)
  Duel.ConfirmCards(1-tp,g)
  Duel.ShuffleHand(tp)
end
function c99970900.thfilter(c)
  return c:IsCode(99970920) and c:IsAbleToHand()
end
function c99970900.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970900.spfilter,tp,LOCATION_HAND,0,3,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c99970900.spfilter,tp,LOCATION_HAND,0,3,3,nil)
  Duel.ConfirmCards(1-tp,g)
  Duel.ShuffleHand(tp)
end
function c99970900.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970900.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970900.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970900.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99970900.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970900.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroupCount(c99970900.drfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end
function c99970900.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler() 
  local ct=Duel.GetMatchingGroupCount(c99970900.drfilter,c:GetControler(),LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(ct)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c99970900.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end