--SAO - Asuna ALO old
function c99990120.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,9999))
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetHintTiming(TIMING_BATTLE_PHASE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE) 
  e1:SetCountLimit(1)
  e1:SetCondition(c99990120.acon)
  e1:SetTarget(c99990120.atktg)
  e1:SetOperation(c99990120.aop)
  c:RegisterEffect(e1)
  --Cannot attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_CANNOT_ATTACK)
  c:RegisterEffect(e2)
  --Cannot be destroyed by battle
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  --ATK/DEF
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990120.atkcon)
  e4:SetOperation(c99990120.atkop)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_BATTLE_DESTROYED)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99990120.atkcon2)
  e5:SetOperation(c99990120.atkop)
  c:RegisterEffect(e5)
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_ATKCHANGE)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e6:SetCode(EVENT_BATTLE_DESTROYED)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCondition(c99990120.atkcon3)
  e6:SetOperation(c99990120.atkop)
  c:RegisterEffect(e6)
end
function c99990120.acon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
  and ((a and a:IsControler(tp) and a:IsFaceup() and a:IsSetCard(9999))
  or (d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(9999)))
end
function c99990120.filter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(9999)
end
function c99990120.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if chk==0 then
  if a:IsControler(tp) then return a:IsCanBeEffectTarget(e)
  else return d:IsCanBeEffectTarget(e) end
  end
  if a:IsControler(tp) then return Duel.SetTargetCard(a)
  else return Duel.SetTargetCard(d) end
end
function c99990120.aop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()  
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local atk=Duel.GetMatchingGroupCount(c99990120.filter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(atk)
  tc:RegisterEffect(e1)
  end
end
function c99990120.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  return tc:IsReason(REASON_BATTLE) and bc:IsRelateToBattle() and bc:IsControler(tp) and bc:IsSetCard(9999)
end
function c99990120.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif tc:IsType(TYPE_MONSTER) and bc:IsControler(tp) and bc:IsSetCard(9999) and tc:IsReason(REASON_BATTLE) and bc:IsReason(REASON_BATTLE) then return true end
end
function c99990120.atkcon3(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif bc:IsType(TYPE_MONSTER) and tc:IsControler(tp) and tc:IsSetCard(9999) and bc:IsReason(REASON_BATTLE) and tc:IsReason(REASON_BATTLE) then return true end
end
function c99990120.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(200)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end