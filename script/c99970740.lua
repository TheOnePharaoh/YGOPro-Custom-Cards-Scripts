--DAL - Ruler
function c99970740.initial_effect(c)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99970740.splimit)
  c:RegisterEffect(e1)
  --Negate Attack/Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970740,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetRange(LOCATION_HAND)
  e2:SetValue(1)
  e2:SetCondition(c99970740.condition)
  e2:SetTarget(c99970740.target)
  e2:SetOperation(c99970740.operation)
  c:RegisterEffect(e2)
  --Negate activation
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970740,0))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99970740.negcost)
  e2:SetCondition(c99970740.negcon)
  e2:SetTarget(c99970740.negtg)
  e2:SetOperation(c99970740.negop)
  c:RegisterEffect(e2)
end
function c99970740.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9997)
end
function c99970740.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c99970740.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99970740.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
  Duel.NegateAttack()
  end
end
function c99970740.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99970740.negcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
  return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99970740.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99970740.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.NegateActivation(ev)~=0 then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(100)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  end
end