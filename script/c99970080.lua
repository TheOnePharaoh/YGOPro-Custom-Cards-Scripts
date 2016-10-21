--DAL - Efreet
function c99970080.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970080.splimit)
  c:RegisterEffect(e1)
  --Cannot be destroyed
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e2:SetCountLimit(1)
  e2:SetValue(c99970080.valcon)
  c:RegisterEffect(e2)
  --Destroy
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970080,0))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99970080.descon)
  e3:SetTarget(c99970080.destg)
  e3:SetOperation(c99970080.desop)
  c:RegisterEffect(e3)
  --200 ATK
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99970080.atkcon)
  e4:SetOperation(c99970080.atkop)
  c:RegisterEffect(e4)
  --100 ATK
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_BATTLE_DESTROYED)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99970080.atkcon2)
  e5:SetOperation(c99970080.atkop2)
  c:RegisterEffect(e5)
end
function c99970080.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970080.valcon(e,re,r,rp)
  return bit.band(r,REASON_BATTLE)~=0
end
function c99970080.descon(e)
  return not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c99970080.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970080.desop(e)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end
function c99970080.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and bc:IsReason(REASON_BATTLE) then  return true 
  elseif tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not bc:IsReason(REASON_BATTLE) then  return false
  end 
end
function c99970080.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(200)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
function c99970080.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  if tc==nil then return false
  elseif tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and bc:IsReason(REASON_BATTLE) then  return false
  elseif tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not bc:IsReason(REASON_BATTLE) then  return true
  end 
end
function c99970080.atkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end