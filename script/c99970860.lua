--DAL - Inverse Angel - Devil
function c99970860.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970660,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99970860.spcon)
  e1:SetOperation(c99970860.spop)
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
  e3:SetCondition(c99970860.discon)
  e3:SetTarget(c99970860.distg)
  e3:SetOperation(c99970860.disop)
  c:RegisterEffect(e3)
  --Cannot activate monster's effects
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetOperation(c99970860.atkop)
  c:RegisterEffect(e4)
  --Negate effect
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e5:SetDescription(aux.Stringid(99970860,1))
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
  e5:SetCode(EVENT_CHAINING)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1)
  e5:SetCondition(c99970860.negcon)
  e5:SetCost(c99970860.negcost)
  e5:SetTarget(c99970860.negtg)
  e5:SetOperation(c99970860.negop)
  c:RegisterEffect(e5)
  --Re-Summon
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
  e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e6:SetCode(EVENT_PHASE+PHASE_END)
  e6:SetRange(LOCATION_REMOVED)
  e6:SetCountLimit(1)
  e6:SetTarget(c99970860.sumtg)
  e6:SetOperation(c99970860.sumop)
  c:RegisterEffect(e6)
  --ATK UP
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE)
  e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e7:SetRange(LOCATION_MZONE)
  e7:SetCode(EFFECT_UPDATE_ATTACK)
  e7:SetValue(c99970860.value)
  c:RegisterEffect(e7)
end
function c99970860.spfilter(c)
  return c:IsCode(99970760) and c:IsAbleToRemoveAsCost()
end
function c99970860.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970860.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c99970860.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970860.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c99970860.discon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99970860.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,c) end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99970860.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()>0 then
  local sg=g:RandomSelect(1-tp,1)
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  end
end
function c99970860.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970860.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970860.aclimit(e,re,tp)
  return re:IsActiveType(TYPE_MONSTER)
end
function c99970860.filter2(c)
  return c:IsType(TYPE_MONSTER)
end
function c99970860.negcon(e,tp,eg,ep,ev,re,r,rp)
  return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99970860.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99970860.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99970860.negop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c99970860.filter2,tp,0,LOCATION_GRAVE,nil)
  local val=sg:GetCount()*100
  if Duel.NegateActivation(ev)~=0 and Duel.Destroy(eg,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,val,REASON_EFFECT)
  e:GetHandler():RegisterFlagEffect(99970860,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
  end
end
function c99970860.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(99970860)>0
  and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99970860.sumop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if e:GetHandler():IsRelateToEffect(e) then
  Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
  end
end
function c99970860.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end