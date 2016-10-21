--DAL - Gabriel
function c99970560.initial_effect(c)
  --Actuvate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99970560.target)
  e1:SetOperation(c99970560.operation)
  c:RegisterEffect(e1)
end
function c99970560.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970560.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970560.filter3(c)
  return c:IsPosition(POS_FACEUP_DEFENSE)
end
function c99970560.filter4(c)
  return c:IsSetCard(9997) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(99970560) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99970560.filter5(c)
  return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c99970560.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingMatchingCard(c99970560.filter2,tp,LOCATION_MZONE,0,1,nil)
  local b2=Duel.IsExistingMatchingCard(c99970560.filter3,tp,0,LOCATION_MZONE,1,nil)
  local b3=Duel.IsExistingTarget(c99970560.filter4,tp,LOCATION_GRAVE,0,1,nil)
  if chk==0 then return b1 or b2 or b3 end
  local off=1
  local ops={}
  local opval={}
  if b1 then
  ops[off]=aux.Stringid(99970560,0)
  opval[off-1]=1
  off=off+1
  end
  if b2 then
  ops[off]=aux.Stringid(99970560,1)
  opval[off-1]=2
  off=off+1
  end
  if b3 then
  ops[off]=aux.Stringid(99970560,2)
  opval[off-1]=3
  off=off+1
  end
  if Duel.GetMatchingGroupCount(c99970560.filter2,tp,LOCATION_MZONE,0,nil)==1 and Duel.IsExistingTarget(c99970560.filter5,tp,0,LOCATION_MZONE,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970560,3)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
  local g=Duel.SelectTarget(tp,c99970560.filter5,tp,0,LOCATION_MZONE,1,1,nil)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,PHASE_END,1) then
  if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
  Duel.Destroy(tc,REASON_EFFECT)
  end
  end
  end
  local op=Duel.SelectOption(tp,table.unpack(ops))
  local sel=opval[op]
  e:SetLabel(sel)
end
function c99970560.operation(e,tp,eg,ep,ev,re,r,rp)
  local sel=e:GetLabel()
  local c=e:GetHandler() 
  if sel==1 then
  local g=Duel.GetMatchingGroup(c99970560.filter1,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(Duel.GetMatchingGroupCount(c99970560.filter2,c:GetControler(),LOCATION_MZONE,0,nil)*200)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
  elseif sel==2 then
  local g=Duel.GetMatchingGroup(c99970560.filter3,tp,0,LOCATION_MZONE,nil)
  if g:GetCount()>0 then
  Duel.ChangePosition(g,POS_FACEUP_ATTACK)
  end
  else
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970560.filter4,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end