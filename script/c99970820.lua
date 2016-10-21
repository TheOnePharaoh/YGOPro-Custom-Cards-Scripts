--DAL - Date's Guard
function c99970820.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(c99970820.condition)
  e1:SetOperation(c99970820.activate)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCondition(c99970820.condition2)
  e2:SetOperation(c99970820.activate)
  c:RegisterEffect(e2)  
end
function c99970820.filter1(c,p)
  return c:GetControler()==p and c:IsFaceup() and  c:IsSetCard(9997) and c:IsType(TYPE_MONSTER) and not c:IsCode(99970160)
end
function c99970820.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970820.filter3(c)
  return c:IsCode(99970160) and c:IsAbleToRemoveAsCost()
end
function c99970820.filter4(e,re,rp)
  return e:GetHandlerPlayer()~=rp
end
function c99970820.filter5(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970820.condition(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsChainNegatable(ev) then return false end
  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
  return ex and tg~=nil and tc+tg:FilterCount(c99970820.filter1,nil,tp)-tg:GetCount()>0 
  and Duel.IsExistingMatchingCard(c99970820.filter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil) 
  and not Duel.IsExistingMatchingCard(c99970820.filter5,tp,LOCATION_MZONE,0,2,nil) and e:GetHandlerPlayer()~=rp
end
function c99970820.activate(e,tp,eg,ep,ev,re,r,rp)
  if chk==0 then return  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g1=Duel.SelectMatchingCard(tp,c99970820.filter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  local tg1=g1:GetFirst()
  if tg1==nil then return end
  Duel.Remove(tg1,POS_FACEUP,REASON_EFFECT)
  if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_REMOVED)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
  e1:SetCondition(c99970820.thcon)
  e1:SetOperation(c99970820.thop)
  e1:SetLabel(0)
  tg1:RegisterEffect(e1)
  local g2=Duel.GetMatchingGroup(c99970820.filter2,tp,LOCATION_MZONE,0,nil)
  local tc2=g2:GetFirst()
  while tc2 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(c99970820.filter4)
  tc2:RegisterEffect(e1,true)
  tc2=g2:GetNext()
  end
end
function c99970820.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970820.thop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  e:GetHandler():SetTurnCounter(ct+0)
  if ct==0 then
  Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,e:GetHandler())
  else e:SetLabel(1) end
end
function c99970820.condition2(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsChainNegatable(ev) then return false end
  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
  return ex and tg~=nil and tc+tg:FilterCount(c99970820.filter1,nil,tp)-tg:GetCount()>0 
  and Duel.IsExistingMatchingCard(c99970820.filter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil)
  and Duel.IsExistingMatchingCard(c99970820.filter5,tp,LOCATION_MZONE,0,2,nil) and e:GetHandlerPlayer()~=rp
end