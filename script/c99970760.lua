--DAL - Angel
function c99970760.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970760.splimit)
  c:RegisterEffect(e1)
  --Cannot activate monster's effect
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetOperation(c99970760.atkop)
  c:RegisterEffect(e2)
  --Negate effect
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970760,0))
  e3:SetCategory(CATEGORY_NEGATE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_CHAINING)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99970760.negcon)
  e3:SetCost(c99970760.negcost)
  e3:SetTarget(c99970760.negtg)
  e3:SetOperation(c99970760.negop)
  c:RegisterEffect(e3)
  --Re-Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970760,1))
  e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetCode(EVENT_PHASE+PHASE_END)
  e4:SetRange(LOCATION_REMOVED)
  e4:SetCountLimit(1)
  e4:SetTarget(c99970760.sumtg)
  e4:SetOperation(c99970760.sumop)
  c:RegisterEffect(e4)
  --100 ATK
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EFFECT_UPDATE_ATTACK)
  e5:SetValue(c99970760.value)
  c:RegisterEffect(e5)
end
function c99970760.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970760.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970760.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970760.aclimit(e,re,tp)
  return re:IsActiveType(TYPE_MONSTER)
end
function c99970760.negcon(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c99970760.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99970760.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  end
end
function c99970760.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if Duel.NegateActivation(ev)~=0 then
  e:GetHandler():RegisterFlagEffect(99970760,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
  end
end
function c99970760.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(99970760)>0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99970760.sumop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if e:GetHandler():IsRelateToEffect(e) then
  Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99970760.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)*100
end