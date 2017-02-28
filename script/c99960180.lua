--BRS - Orange Of Smiles
function c99960180.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960180,0))
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960180+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99960180.tdtg)
  e1:SetOperation(c99960180.tdop)
  c:RegisterEffect(e1)
  --Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960180,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1,99960180+EFFECT_COUNT_CODE_OATH)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99960180.thcost)
  e2:SetTarget(c99960180.thtg)
  e2:SetOperation(c99960180.thop)
  c:RegisterEffect(e2)
end
function c99960180.tdfilter1(c)
  return c:IsFaceup() and c:IsAbleToDeck()
end
function c99960180.tdfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsAbleToDeck()
end
function c99960180.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return Duel.IsExistingTarget(c99960180.tdfilter1,tp,0,LOCATION_MZONE,1,nil)
  and Duel.IsExistingTarget(c99960180.tdfilter2,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g1=Duel.SelectTarget(tp,c99960180.tdfilter1,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99960180.tdfilter2,tp,LOCATION_MZONE,0,1,1,nil)
  g1:Merge(g2)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c99960180.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
  local tc=g:GetFirst()
  while tc do
  if tc:IsSetCard(0x996) and tc:GetPreviousControler()==tp and tc:IsLocation(LOCATION_DECK) then
  Duel.ShuffleDeck(tp)
  end
  tc=g:GetNext()
  end
  if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
  Duel.ConfirmDecktop(tp,1)
  local g=Duel.GetDecktopGroup(tp,1)
  local tc=g:GetFirst()
  if (tc:IsCode(99960200) or tc:IsCode(99960220) or tc:IsCode(99960240) or tc:IsCode(99960260)) and tc:IsAbleToHand() then
  Duel.Recover(tp,1000,REASON_EFFECT)
  end
  end
end
function c99960180.thfilter(c)
  return (c:IsCode(99960200) or c:IsCode(99960220) or c:IsCode(99960240) or c:IsCode(99960260)) and c:IsAbleToHand()
end
function c99960180.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99960180.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960180.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960180.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960180.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end