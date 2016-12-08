--SAO - The Skull Reaper
function c99990320.initial_effect(c)
  c:EnableReviveLimit()
  --Cannot be Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990320,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99990320.spcon)
  e2:SetOperation(c99990320.spop)
  c:RegisterEffect(e2)
  --Halve ATK
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetCondition(c99990320.atkcon)
  e3:SetOperation(c99990320.atkop)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e4)
  local e5=e3:Clone()
  e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e5)
  --Cannot be targeted
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e6:SetValue(1)
  c:RegisterEffect(e6)
  --Discard
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_DAMAGE)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e7:SetCode(EVENT_BATTLE_DESTROYING)
  e7:SetCondition(c99990320.discon)
  e7:SetTarget(c99990320.distg)
  e7:SetOperation(c99990320.disop)
  c:RegisterEffect(e7)
end
function c99990320.spfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990320.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990320.spfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c99990320.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990320.spfilter,tp,LOCATION_GRAVE,0,3,3,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99990320.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c99990320.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=tg:GetFirst()
  while tc do
  local atk=tc:GetAttack()
  local def=tc:GetDefense()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(atk/2)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e2:SetValue(def/2)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e2)
  tc=tg:GetNext()
  end
end
function c99990320.discon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
  and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
end
function c99990320.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99990320.disop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
  local dg=g:RandomSelect(tp,1)
  Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
end