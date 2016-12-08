--SAO - Asuna ALO B.
function c99990120.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x999))
  c:EnableReviveLimit()
  --Draw
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCondition(c99990120.drcon)
  e1:SetTarget(c99990120.drtg)
  e1:SetOperation(c99990120.drop)
  c:RegisterEffect(e1)
  --ATK Up
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99990120.atkcon1)
  e2:SetOperation(c99990120.atkop1)
  c:RegisterEffect(e2)
  --ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990120.atkcon2)
  e3:SetOperation(c99990120.atkop2)
  c:RegisterEffect(e3)
end
function c99990120.drcon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c99990120.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990120.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local ct=Duel.GetMatchingGroupCount(c99990120.drfilter,tp,LOCATION_MZONE,0,c)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) and ct>0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(ct)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c99990120.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function c99990120.atkfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990120.atkcon1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  local bc=Duel.GetAttackTarget()
  if not bc then return false end
  if bc:IsControler(1-tp) then bc=tc end
  e:SetLabelObject(bc)
  local ct=Duel.GetMatchingGroupCount(c99990120.atkfilter,tp,LOCATION_GRAVE,0,nil)
  return bc:IsFaceup() and bc:IsSetCard(0x999) and ct>0
end
function c99990120.atkop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=e:GetLabelObject()
  local ct=Duel.GetMatchingGroupCount(c99990120.atkfilter,tp,LOCATION_GRAVE,0,nil)
  if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(ct*200)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  end
end
function c99990120.atkcon2(e,tp,eg,ep,ev,re,r,rp)
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
function c99990120.atkop2(e,tp,eg,ep,ev,re,r,rp)
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