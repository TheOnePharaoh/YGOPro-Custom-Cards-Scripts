--SAO - Klein SAO
function c99990340.initial_effect(c)
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e1:SetValue(c99990340.val)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetCondition(c99990340.drcon)
  e2:SetTarget(c99990340.drtg)
  e2:SetOperation(c99990340.drop)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990340.atkcon)
  e3:SetOperation(c99990340.atkop)
  c:RegisterEffect(e3)
end
function c99990340.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990340.val(e,c)
  return Duel.GetMatchingGroupCount(c99990340.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*200
end
function c99990340.drcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_BATTLE)
end
function c99990340.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990340.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function c99990340.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990340.atkop(e,tp,eg,ep,ev,re,r,rp)
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