--DAL - Witch
function c99970700.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970700.splimit)
  c:RegisterEffect(e1)
  --Negate ATK
  local e2=Effect.CreateEffect(c)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99970700.condition)
  e2:SetTarget(c99970700.target)
  e2:SetOperation(c99970700.operation)
  c:RegisterEffect(e2)
  --Copy ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970700,0))
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99970700.lvtg)
  e3:SetOperation(c99970700.lvop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99970700.atkval)
  c:RegisterEffect(e4)
end
function c99970700.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970700.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp)
end
function c99970700.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tg=Duel.GetAttacker()
  if chkc then return chkc==tg end
  if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
  Duel.SetTargetCard(tg)
end
function c99970700.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  Duel.NegateAttack()
  Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
end
function c99970700.filter1(c,lv)
  return c:IsFaceup()
end
function c99970700.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99970700.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970700.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970700,0))
  Duel.SelectTarget(tp,c99970700.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c99970700.lvop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local atk=tc:GetBaseAttack()
  local def=tc:GetBaseDefense()
  if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  e2:SetValue(def)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
  c:RegisterEffect(e2)
  end
end
function c99970700.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970700.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970700.filter2,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end