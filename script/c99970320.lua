--DAL - Zaphkiel
function c99970320.initial_effect(c)
  --Effects
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99970320.target)
  e1:SetOperation(c99970320.operation)
  c:RegisterEffect(e1)
end
function c99970320.filter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99970320.filter2(c)
  return c:IsFaceup() and c:IsType(TYPE_EFFECT) 
end
function c99970320.filter3(c,e,tp)
  return c:IsSetCard(9997) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99970320.filter4(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970320.filter5(c)
  return c:IsSetCard(9997) and c:IsAbleToRemove()
end
function c99970320.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingTarget(c99970320.filter1,tp,LOCATION_MZONE,0,1,nil) 
  local b2=Duel.IsExistingTarget(c99970320.filter2,tp,0,LOCATION_MZONE,1,nil) 
  local b3=Duel.IsExistingMatchingCard(c99970320.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
  if chk==0 then return b1 or b2 or b3 end
  local off=1
  local ops={}
  local opval={}
  if b1 then
  ops[off]=aux.Stringid(99970320,0)
  opval[off-1]=1
  off=off+1
  end
  if b2 then
  ops[off]=aux.Stringid(99970320,1)
  opval[off-1]=2
  off=off+1
  end
  if b3 then
  ops[off]=aux.Stringid(99970320,2)
  opval[off-1]=3
  off=off+1
  end
  if Duel.GetMatchingGroupCount(c99970320.filter4,tp,LOCATION_MZONE,0,nil)==1 and Duel.IsExistingTarget(c99970320.filter5,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970320,3))  then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970320.filter5,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  local tg=g:GetFirst()
  if tg==nil then return end
  Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_REMOVED)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
  e1:SetCondition(c99970320.thcon)
  e1:SetOperation(c99970320.thop)
  e1:SetLabel(0)
  e1:SetLabelObject(tg)
  Duel.RegisterEffect(e1,tp)
  Duel.ShuffleDeck(tp)
  end
  end
  local op=Duel.SelectOption(tp,table.unpack(ops))
  local sel=opval[op]
  e:SetLabel(sel)
end
function c99970320.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local sel=e:GetLabel()
  if sel==1 then
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970320,4))
  local g=Duel.SelectTarget(tp,c99970320.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  local tc=g:GetFirst()
  if tc:IsRelateToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  tc:RegisterEffect(e2)
  end
  elseif sel==2 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c99970320.filter2,tp,0,LOCATION_MZONE,1,1,nil)
  local tc=g:GetFirst()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.NegateRelatedChain(tc,RESET_TURN_SET)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_CANNOT_TRIGGER)
  e2:SetValue(RESET_TURN_SET)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e2)
  end
  else
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970320.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end
function c99970320.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970320.thop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  e:GetHandler():SetTurnCounter(ct+1)
  if ct==1 then
  local tc=e:GetLabelObject()
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  else e:SetLabel(1) end
end