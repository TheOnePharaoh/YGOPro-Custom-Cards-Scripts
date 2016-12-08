--HN - Oblivion Conflict
function c99980680.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCondition(c99980680.condition)
  e1:SetTarget(c99980680.target)
  e1:SetOperation(c99980680.operation)
  c:RegisterEffect(e1)
end
function c99980680.confilter(c)
  return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99980680.condition(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
  and Duel.IsExistingMatchingCard(c99980680.confilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99980680.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function c99980680.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980680.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99980680.atkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980680.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99980680.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99980680.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  local g=Duel.GetMatchingGroup(c99980680.atkfilter,tp,LOCATION_MZONE,0,nil)
  local val=g:GetCount()*500
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(val)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e2:SetOperation(c99980680.atkop)
  tc:RegisterEffect(e2)
  end
end
function c99980680.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99980680.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99980680.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
