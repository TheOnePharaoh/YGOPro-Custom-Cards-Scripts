--SAO - The Gleam Eyes
function c99990280.initial_effect(c)
  c:EnableReviveLimit()
  --Cannot be Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e1)
  --Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990280,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99990280.spcon)
  e2:SetOperation(c99990280.spop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99990280.val)
  c:RegisterEffect(e3)
  --Damage
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990280.damcon)
  e4:SetTarget(c99990280.damtg)
  e4:SetOperation(c99990280.damop)
  c:RegisterEffect(e4)
  --Second Attack
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_BATTLED)
  e5:SetCondition(c99990280.atcon)
  e5:SetOperation(c99990280.atop)
  c:RegisterEffect(e5)
end
function c99990280.spfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990280.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990280.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c99990280.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990280.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99990280.val(e,c)
  return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*100
end
function c99990280.damcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  if tc:IsType(TYPE_XYZ) then
  e:SetLabel(tc:GetRank()) 
  else
  e:SetLabel(tc:GetLevel())
  end
  return eg:GetCount()==1 and tc:GetReasonCard()==e:GetHandler()
  and tc:IsReason(REASON_BATTLE) 
end
function c99990280.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(e:GetLabel()*100)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*100)
end
function c99990280.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function c99990280.atcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(99990280)==0
  and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c99990280.atop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChainAttack()
end