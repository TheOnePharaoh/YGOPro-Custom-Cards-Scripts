--DAL - Halvanhelev
function c99970180.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99970180.cost)
  e1:SetTarget(c99970180.target)
  e1:SetOperation(c99970180.operation)
  c:RegisterEffect(e1)
end
function c99970180.filter1(c)
  return c:IsCode(99970140) and c:IsAbleToRemoveAsCost()
end
function c99970180.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970180.filter3(c)
  return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970180.filter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local rg=Duel.SelectMatchingCard(tp,c99970180.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c99970180.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970180.filter2(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970180.filter2,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.GetMatchingGroupCount(c99970180.filter2,tp,LOCATION_MZONE,0,nil)==1 and Duel.IsExistingMatchingCard(c99970180.filter3,tp,0,LOCATION_ONFIELD,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970180,0)) then
  local sg=Duel.GetMatchingGroup(c99970180.filter3,tp,0,LOCATION_ONFIELD,e:GetHandler())
  Duel.Destroy(sg,REASON_EFFECT)
  end
end
function c99970180.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()  
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970180,1))
  local g=Duel.SelectTarget(tp,c99970180.filter2,tp,LOCATION_MZONE,0,1,1,nil)   
  local tc=g:GetFirst()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(1000+Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)*100)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end