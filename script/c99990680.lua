--SAO - Journey's End
function c99990680.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990680+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99990680.cost)
  e1:SetTarget(c99990680.target)
  e1:SetOperation(c99990680.operation)
  c:RegisterEffect(e1)
end
function c99990680.filter1(c)
  return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99990680.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990680.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetAttack())
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990680.filter2(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990680.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,2,nil) 
  and not Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) 
  or (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) or Duel.IsPlayerCanDraw(tp,2) end
end    
function c99990680.operation(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(c))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,2,nil) 
  and not Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) 
  or (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) and Duel.IsPlayerCanDraw(tp,2) then
  select=Duel.SelectOption(tp,aux.Stringid(99990680,0),aux.Stringid(99990680,1))
  elseif (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,2,nil) 
  and not Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) 
  or (Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99990680.filter1,tp,LOCATION_HAND,0,1,nil)) then
  select=Duel.SelectOption(tp,aux.Stringid(99990680,0))
  elseif Duel.IsPlayerCanDraw(tp,2) then
  select=Duel.SelectOption(tp,aux.Stringid(99990680,1))
  select=1
  end
  if select==0 then
  local g=Duel.GetMatchingGroup(c99990680.filter2,tp,LOCATION_MZONE,0,nil)
  local atk=e:GetLabel()
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk/2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
  else
  Duel.Draw(tp,2,REASON_EFFECT)
  end
end