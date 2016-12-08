--SAO - Yuuki ALO
function c99990440.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x999))
  c:EnableReviveLimit()
  --ATK Lose
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990440.atklcon)
  e1:SetOperation(c99990440.atklop)
  c:RegisterEffect(e1)
  --Attack All
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ATTACK_ALL)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990440.atkcon)
  e3:SetOperation(c99990440.atkop)
  c:RegisterEffect(e3)
end
function c99990440.atklcon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO 
  and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c99990440.atklfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990440.atklop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  local val=Duel.GetMatchingGroupCount(c99990440.atklfilter,e:GetOwnerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-100*val)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
end
function c99990440.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a,d=d,a end
  if d:IsType(TYPE_XYZ) then
  e:SetLabel(d:GetRank()) 
  else
  e:SetLabel(d:GetLevel())
  end
  return a:IsControler(tp) and a:IsSetCard(0x999) and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99990440.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end