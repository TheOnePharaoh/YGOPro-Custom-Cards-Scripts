--Nightmare Shot
function c99970360.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(c99970360.condition)
  e1:SetTarget(c99970360.target)
  e1:SetOperation(c99970360.activate)
  c:RegisterEffect(e1)
end
function c99970360.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970360.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99970360.filter1,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c99970360.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  if Duel.IsExistingTarget(c99970360.filter1,tp,LOCATION_MZONE,0,2,nil) then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
  end
end
function c99970360.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local v=e:GetLabel()
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  if v==1 and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(99970360,0)) then
  Duel.BreakEffect()
  c:CancelToGrave()
  Duel.ChangePosition(c,POS_FACEDOWN)
  Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
  end
  end
end