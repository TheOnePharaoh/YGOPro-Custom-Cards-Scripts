--DAL - Zadkiel
function c99970380.initial_effect(c)
  --Acrivate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99970380.target)
  e1:SetOperation(c99970380.activate)
  c:RegisterEffect(e1)
end
function c99970380.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970380.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  if Duel.GetMatchingGroupCount(c99970380.filter1,tp,LOCATION_MZONE,0,nil)==1 then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970380.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()  
  local v=e:GetLabel() 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)        
  if v==1 then
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,2,nil)
  local tc=g:GetFirst()
  while tc do
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
  if tc:IsDefenseBelow(0) and Duel.Destroy(tc,REASON_EFFECT)~=0 then  
  Duel.Damage(1-tp,700,REASON_EFFECT)
  elseif not tc:IsDefenseBelow(0) then 
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(0)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e2:SetValue(0)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e2)
  end
  end
  tc=g:GetNext()
  end
  else
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  local tc=g:GetFirst()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
  if tc:IsDefenseBelow(0) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
  Duel.Damage(1-tp,700,REASON_EFFECT)
  elseif not tc:IsDefenseBelow(0) then 
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(0)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e2:SetValue(0)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e2)
  end
  end
  end
end