--DAL - Sandalphon
function c99970140.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970140.target)
  e1:SetOperation(c99970140.operation)
  c:RegisterEffect(e1)
end
function c99970140.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970140.filter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99970140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970140.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970140.filter1,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.GetMatchingGroupCount(c99970140.filter1,tp,LOCATION_MZONE,0,nil)==1 and Duel.IsExistingMatchingCard(c99970140.filter2,tp,0,LOCATION_ONFIELD,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970140,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g1=Duel.SelectTarget(tp,c99970140.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g1:GetCount()>0 then
  Duel.Destroy(g1,REASON_EFFECT)
  end
  end
end
function c99970140.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970140,1))
  local g=Duel.SelectTarget(tp,c99970140.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  local tc=g:GetFirst()    
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(500+Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)*100)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end