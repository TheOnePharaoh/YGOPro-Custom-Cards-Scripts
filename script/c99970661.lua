--DAL - Inverse Princess - Demon Lord
function c99970661.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970661,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99970661.spcon)
  e1:SetOperation(c99970661.spop)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --Cannot be Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e2)
  --Discard
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_HANDES)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c99970661.discon)
  e3:SetTarget(c99970661.distg)
  e3:SetOperation(c99970661.disop)
  c:RegisterEffect(e3)
  --Cannot activate spell/trap
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetOperation(c99970661.atkop)
  c:RegisterEffect(e4)
  --Destroy 1 spell/trap 
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970661,1))
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(c99970661.destg)
  e5:SetOperation(c99970661.desop)
  c:RegisterEffect(e5)
  --ATK UP
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_UPDATE_ATTACK)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetValue(c99970661.val)
  c:RegisterEffect(e6)
end
function c99970661.spfilter(c)
  return c:IsCode(99970040) and c:IsAbleToRemoveAsCost()
end
function c99970661.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970661.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c99970661.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970661.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c99970661.discon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99970661.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,c) end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99970661.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
  local sg=g:RandomSelect(1-tp,1)
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  end
end
function c99970661.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970661.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970661.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99970661.filter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99970661.filter3(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970661.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99970661.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970661.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970661.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
  local sg=Duel.GetMatchingGroup(c99970661.filter3,tp,0,LOCATION_GRAVE,nil)
  local val=sg:GetCount()*100
  Duel.Damage(1-tp,val,REASON_EFFECT)
  end
end
function c99970661.val(e,c)
  local tp=c:GetControler()
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)*100
end