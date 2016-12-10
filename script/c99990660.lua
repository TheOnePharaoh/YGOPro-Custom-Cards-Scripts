--SAO - Bits Of Sorrow
function c99990660.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_BATTLE_DESTROYED)
  e1:SetHintTiming(TIMING_END_PHASE)
  e1:SetCondition(c99990660.condition)
  e1:SetTarget(c99990660.target)
  e1:SetOperation(c99990660.operation)
  c:RegisterEffect(e1)

  if c99990660.counter==nil then
  c99990660.counter=true
  c99990660[0]=0
  c99990660[1]=0
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
  e2:SetOperation(c99990660.resetcount)
  Duel.RegisterEffect(e2,0)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetOperation(c99990660.addcount)
  Duel.RegisterEffect(e3,0)
  end
end
function c99990660.resetcount(e,tp,eg,ep,ev,re,r,rp)
  c99990660[0]=0
  c99990660[1]=0
end
function c99990660.addcount(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  while tc do
  local pl=tc:GetPreviousLocation()
  if pl==LOCATION_MZONE and tc:IsSetCard(0x999) and tc:GetPreviousControler()==tp then
  local p=tc:GetPreviousControler()
  c99990660[p]=c99990660[p]+1
  end
  tc=eg:GetNext()
  end
end
function c99990660.filter1(c,tp)
  return c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:IsSetCard(0x999)
end
function c99990660.filter2(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990660.condition(e,tp,eg,ep,ev,re,r,rp,chk)
  return eg:IsExists(c99990660.filter1,1,nil,tp)
end
function c99990660.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c99990660.filter2,tp,LOCATION_MZONE,0,1,nil) end
  local val=eg:Filter(c99990660.filter1,nil,tp):GetFirst():GetBaseAttack()
  e:SetLabel(val)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99990660.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990660.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local val=e:GetLabel()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(val/2)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetOperation(c99990660.droperation)
  Duel.RegisterEffect(e1,tp)
end
function c99990660.droperation(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99990660)
  Duel.Draw(tp,c99990660[tp],REASON_EFFECT)
end