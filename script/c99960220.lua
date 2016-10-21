--BRS - Blue Of Tears
function c99960220.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960220,0))
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960220)
  e1:SetTarget(c99960220.tdtg)
  e1:SetOperation(c99960220.tdop)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960220,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1,99960220)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99960220.cost)
  e2:SetTarget(c99960220.target)
  e2:SetOperation(c99960220.operation)
  c:RegisterEffect(e2)
end
function c99960220.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER)
end
function c99960220.filter2(c)
  return c:IsFaceup() and c:IsAbleToHand()
end
function c99960220.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960220.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960220.filter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960220.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99960220.tdop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingTarget(c99960220.filter1,tp,LOCATION_MZONE,0,1,nil) then return end
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
  if Duel.IsExistingMatchingCard(c99960220.filter2,tp,0,LOCATION_MZONE,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(tp,c99960220.filter2,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
  if g2:GetCount()>0 then
  local tc2=g2:GetFirst()
  Duel.SendtoHand(tc2,nil,REASON_EFFECT)
  end
  end
  end
end
function c99960220.filter3(c)
  return (c:IsCode(99960180) or c:IsCode(99960200) or c:IsCode(99960240) or c:IsCode(99960260)) and c:IsAbleToHand()
end
function c99960220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99960220.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960220.filter3,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960220.operation(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960220.filter3,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end