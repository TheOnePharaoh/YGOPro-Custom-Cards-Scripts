--SAO - Game Master Rule
function c99990060.initial_effect(c)
  c:SetUniqueOnField(1,0,99990060)
  --Activate 
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99990060.condition1)
  e1:SetTarget(c99990060.target1)
  e1:SetOperation(c99990060.activate1)
  c:RegisterEffect(e1)
  --Activate
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_NEGATE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99990060.condition2)
  e2:SetCost(c99990060.cost2)
  e2:SetTarget(c99990060.target2)
  e2:SetOperation(c99990060.activate2)
  c:RegisterEffect(e2)
  --Negate
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990060,3))
  e3:SetCategory(CATEGORY_DISABLE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(aux.exccon)
  e3:SetCost(c99990060.negcost)
  e3:SetTarget(c99990060.negtg)
  e3:SetOperation(c99990060.negop)
  c:RegisterEffect(e3)
end
function c99990060.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990060.banfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990060.condition1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99990060.filter,tp,LOCATION_MZONE,0,1,nil) 
end
function c99990060.target1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  e:SetLabel(0)
  local ct=Duel.GetCurrentChain()
  if ct==1 or not Duel.IsExistingMatchingCard(c99990060.filter,tp,LOCATION_MZONE,0,1,nil)
  or not (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
  or Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil)) then return false end
  local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
  local tc=te:GetHandler()
  if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ct-1)
  and Duel.SelectYesNo(tp,aux.Stringid(99990060,0)) then
  Duel.HintSelection(Group.FromCards(c))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
  and Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,1),aux.Stringid(99990060,2))
  elseif Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,1))
  elseif Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,2))
  select=1
  end
  if select==0 then
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
  else
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990060.banfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
  e:SetLabel(1)
  end
end
function c99990060.activate1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if e:GetLabel()~=1 or not c:IsRelateToEffect(e) then return end
  local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
  local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
  local tc=te:GetHandler()
  if Duel.NegateEffect(ct-1) and tc:IsRelateToEffect(te) and Duel.IsExistingMatchingCard(c99990060.filter,tp,LOCATION_MZONE,0,1,nil) then
  local g=Duel.GetMatchingGroup(c99990060.filter,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
  end
end
function c99990060.condition2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99990060.filter,tp,LOCATION_MZONE,0,1,nil) 
  and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99990060.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
  or Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.HintSelection(Group.FromCards(c))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
  and Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,1),aux.Stringid(99990060,2))
  elseif Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,1))
  elseif Duel.IsExistingMatchingCard(c99990060.banfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99990060,2))
  select=1
  end
  if select==0 then
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
  else
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990060.banfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  end
end
function c99990060.target2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99990060.activate2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.IsExistingMatchingCard(c99990060.filter,tp,LOCATION_MZONE,0,1,nil) then
  local g=Duel.GetMatchingGroup(c99990060.filter,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
  end
end
function c99990060.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99990060.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c99990060.negop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_DISABLE_EFFECT)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
end