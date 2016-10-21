--DAL - Diva
function c99970541.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970541.splimit)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetTarget(c99970541.thtg)
  e2:SetOperation(c99970541.thop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e4)
  --ATK UP/Down
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970541,0))
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetCondition(c99970541.atkcon)
  e5:SetOperation(c99970541.atkop)
  c:RegisterEffect(e5)
end
function c99970541.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970541.thfilter(c)
  return c:IsSetCard(9997) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end
function c99970541.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970541.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970541.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970541.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end 
function c99970541.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970541.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and  Duel.IsExistingTarget(c99970541.atkfilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
end
function c99970541.atkop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(c99970541.atkfilter,tp,LOCATION_MZONE,0,nil)
  local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc1=g1:GetFirst()
  while tc1 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(-ct*200)
  tc1:RegisterEffect(e1)
  tc1=g1:GetNext()
  end
  local g2=Duel.GetMatchingGroup(c99970541.atkfilter,tp,LOCATION_MZONE,0,nil)
  local tc2=g2:GetFirst()
  while tc2 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(ct*200)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  tc2=g2:GetNext()
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e:GetHandler():RegisterEffect(e1)
end