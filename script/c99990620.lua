--SAO - Halloween Dungeon Party
function c99990620.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990620+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990620.target)
  e1:SetOperation(c99990620.operation)
  c:RegisterEffect(e1)
end
function c99990620.filter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99990620.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990620.filter,tp,LOCATION_DECK,0,3,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99990620.operation(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99990620.filter,tp,LOCATION_DECK,0,nil)
  if g:GetCount()>=3 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=g:Select(tp,3,3,nil)
  Duel.ConfirmCards(1-tp,sg)
  Duel.ShuffleDeck(tp)
  local tg=sg:Select(1-tp,1,1,nil)
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  end
end