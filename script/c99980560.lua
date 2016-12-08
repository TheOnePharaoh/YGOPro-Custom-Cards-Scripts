--Pudding Buddies
function c99980560.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99980560.target)
  e1:SetOperation(c99980560.activate)
  c:RegisterEffect(e1)
end
function c99980560.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980560.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99980560.filter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980560.filter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
  e:SetLabel(ct)
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99980560.activate(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=e:GetLabel()
  Duel.ConfirmDecktop(p,ct)
  local g=Duel.GetDecktopGroup(p,ct)
  if g:GetCount()>0 then
  Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
  local sg=g:Select(p,1,1,nil)
  if sg:GetFirst():IsAbleToHand() then
  Duel.SendtoHand(sg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-p,sg)
  Duel.ShuffleHand(p)
  else
  Duel.SendtoGrave(sg,REASON_RULE)
  end
  Duel.ShuffleDeck(p)
  end
end