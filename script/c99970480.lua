--Spirit Comrade
function c99970480.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetTarget(c99970480.atktg)
  e1:SetOperation(c99970480.atkop)
  c:RegisterEffect(e1)
end
function c99970480.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970480.indtg(e,c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970480.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970480.filter2,tp,LOCATION_MZONE,0,2,nil) and
  Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  if Duel.IsExistingMatchingCard(c99970480.filter1,tp,LOCATION_MZONE,0,3,nil) then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970480.atkop(e,tp,eg,ep,ev,re,r,rp) 
  local v=e:GetLabel()
  local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local g=Duel.GetMatchingGroup(c99970480.filter1,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  if v==1 then
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(500+ct*500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(c99970480.indtg)
  e3:SetReset(RESET_PHASE+PHASE_END)
  e3:SetValue(1)
  Duel.RegisterEffect(e3,tp)
  tc=g:GetNext()
  end
  else 
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(ct*500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(c99970480.indtg)
  e3:SetReset(RESET_PHASE+PHASE_END)
  e3:SetValue(1)
  Duel.RegisterEffect(e3,tp)
  tc=g:GetNext()
  end
end
end