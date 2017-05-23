--DAL - Zadkiel
function c99970380.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970380,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970380+EFFECT_COUNT_CODE_OATH)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970380.target)
  e1:SetOperation(c99970380.activate)
  c:RegisterEffect(e1)
end
function c99970380.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970380.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970380.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970380.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99970380.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970380.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local atk=tc:GetAttack()/2
  local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc1=g1:GetFirst()
  while tc1 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-atk)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc1:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc1:RegisterEffect(e2)
  tc1=g1:GetNext()
  end
  end
  Duel.BreakEffect()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
  --ATK/DEF
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99970380,1))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_BATTLE_START)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetCondition(c99970380.adcon)
  e1:SetTarget(c99970380.adtg)
  e1:SetOperation(c99970380.adop)
  tc:RegisterEffect(e1)
  end
end
function c99970380.adcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:IsFaceup()
end
function c99970380.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970380.adop(e,tp,eg,ep,ev,re,r,rp)
  local bc=e:GetHandler():GetBattleTarget()
  if bc:IsRelateToBattle() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(0)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  bc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  bc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DISABLE)
  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  bc:RegisterEffect(e3)
  local e4=Effect.CreateEffect(e:GetHandler())
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_DISABLE_EFFECT)
  e4:SetValue(RESET_TURN_SET)
  e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  bc:RegisterEffect(e4)
  end
end