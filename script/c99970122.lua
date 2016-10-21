--DAL - Hermit
function c99970122.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970122.splimit)
  c:RegisterEffect(e1)
  --Cannot be attacked
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  e2:SetCondition(c99970122.indcon)
  e2:SetValue(aux.imval1)
  c:RegisterEffect(e2)
  --DEF
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970122,0))
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCode(EFFECT_SET_ATTACK)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99970122.target)
  e3:SetOperation(c99970122.op)
  c:RegisterEffect(e3)
end
function c99970122.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970122.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5) and not c:IsCode(99970120)
end
function c99970122.indcon(e)
  return Duel.IsExistingMatchingCard(c99970122.filter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99970122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99970122.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e1:SetValue(0)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  if tc:IsPosition(POS_FACEUP_ATTACK) then
  Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
  end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  end
end