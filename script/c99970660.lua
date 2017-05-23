--DAL - Inverse Princess - Demon Lord
function c99970660.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon Rule
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970660,0))
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCondition(c99970660.hspcon)
  e1:SetOperation(c99970660.hspop)
  c:RegisterEffect(e1)
  --Destroy + ATK Increase
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970660,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99970660.descon)
  e2:SetTarget(c99970660.destg)
  e2:SetOperation(c99970660.desop)
  c:RegisterEffect(e2)
  --Destroy Replace
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DESTROY_REPLACE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99970660.reptg)
  e3:SetOperation(c99970660.repop)
  c:RegisterEffect(e3)
  --Cannot Activate Spell/Trap
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetOperation(c99970660.atkop)
  c:RegisterEffect(e4)
end
function c99970660.hspfilter(c)
  return c:IsFaceup() and c:IsCode(99970040) and c:IsAbleToRemoveAsCost()
end
function c99970660.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99970660.hspfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99970660.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970660.hspfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99970660.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970660.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970660.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970660.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  local g=Duel.GetMatchingGroup(c99970660.desfilter,tp,0,LOCATION_ONFIELD,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99970660.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(c99970660.desfilter,tp,0,LOCATION_ONFIELD,nil)
  local ct=Duel.Destroy(g,REASON_EFFECT)
  if ct>0 then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(ct*300)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
  end
end
function c99970660.repfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x997) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c99970660.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
  and Duel.IsExistingMatchingCard(c99970660.repfilter,tp,LOCATION_ONFIELD,0,1,c) end
  if Duel.SelectYesNo(tp,aux.Stringid(99970660,2)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
    local g=Duel.SelectMatchingCard(tp,c99970660.repfilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SetTargetCard(g)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
    return true
  else return false end
end
function c99970660.repop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
  Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c99970660.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970660.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970660.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end