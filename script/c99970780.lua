--DAL - Takamiya Mana
function c99970780.initial_effect(c)
  --Special summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970780,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99970780.spcon)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCondition(c99970780.efcon)
  e2:SetOperation(c99970780.efop)
  c:RegisterEffect(e2)
end
function c99970780.filter(c)
  return c:IsFaceup() and c:IsCode(99970160)
end
function c99970780.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99970780.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99970780.efcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0x997)
end
function c99970780.efop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local rc=c:GetReasonCard()
  local p=rc:GetControler()
  if Duel.GetFlagEffect(p,99970780)~=0 then return end
  local e1=Effect.CreateEffect(rc)
  e1:SetDescription(aux.Stringid(99970780,1))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99970780.atkcon)
  e1:SetTarget(c99970780.atktg)
  e1:SetOperation(c99970780.atkop)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  rc:RegisterEffect(e1,true)
  if not rc:IsType(TYPE_EFFECT) then
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ADD_TYPE)
  e2:SetValue(TYPE_EFFECT)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  rc:RegisterEffect(e2,true)
  end
  Duel.RegisterFlagEffect(p,99970780,RESET_PHASE+PHASE_END,0,1)
end
function c99970780.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c99970780.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970780.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  end
end