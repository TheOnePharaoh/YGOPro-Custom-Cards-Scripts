--SAO --Edge of The World
function c99990740.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990740,0))
  e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990740+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990740.target)
  e1:SetOperation(c99990740.operation)
  c:RegisterEffect(e1)
  --To Deck
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990740,1))
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCost(c99990740.tdcost)
  e2:SetTarget(c99990740.tdtg)
  e2:SetOperation(c99990740.tdop)
  c:RegisterEffect(e2)
end
function c99990740.thfilter(c)
  return c:IsSetCard(0x999) and c:IsAbleToHand()
end
function c99990740.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
    return hd>0 and Duel.IsExistingMatchingCard(c99990740.thfilter,tp,LOCATION_DECK,0,hd,nil)
  end
  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
  local tg=Duel.GetMatchingGroup(c99990740.thfilter,tp,LOCATION_DECK,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
end
function c99990740.operation(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
  local tg=Duel.GetMatchingGroup(c99990740.thfilter,tp,LOCATION_DECK,0,nil)
  if ct>0 and tg:GetCount()>=ct then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sel=tg:Select(tp,ct,ct,nil)
    Duel.SendtoHand(sel,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sel)
  end
end
function c99990740.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99990740.tdfilter1(c)
  return c:IsSetCard(0x999) and c:IsAbleToDeck()
end
function c99990740.tdfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990740.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990740.tdfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
  and Duel.IsExistingMatchingCard(c99990740.tdfilter2,tp,LOCATION_MZONE,0,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99990740.tdfilter2,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99990740.tdfilter1,tp,LOCATION_GRAVE,0,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99990740.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
end