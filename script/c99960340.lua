--BRS - Counter Star
function c99960340.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_BE_BATTLE_TARGET)
  e1:SetCondition(c99960340.condition)
  e1:SetTarget(c99960340.target)
  e1:SetOperation(c99960340.operation)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99960340.negcon)
  e2:SetTarget(c99960340.negtg)
  e2:SetOperation(c99960340.negop)
  c:RegisterEffect(e2)
end
function c99960340.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER)
end
function c99960340.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960340.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99960340.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local at=eg:GetFirst()
  local a=Duel.GetAttacker()
  if chk==0 then return at:IsControler(tp) and at:IsOnField() and at:IsFaceup() and a:IsOnField() end
  at:CreateEffectRelation(e)
  a:CreateEffectRelation(e)
end
function c99960340.operation(e,tp,eg,ep,ev,re,r,rp)
  local at=eg:GetFirst()
  local a=Duel.GetAttacker()
  if not a:IsRelateToEffect(e) or not at:IsRelateToEffect(e) or a:IsFacedown() or at:IsFacedown() then return end
  Duel.NegateAttack(a)
  if at:IsType(TYPE_XYZ) then
  local rk=at:GetRank()
  dmg=rk*200
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  elseif not at:IsType(TYPE_XYZ) then
  local lvl=at:GetLevel()
  dmg=lvl*200
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  end
end
function c99960340.negcon(e,tp,eg,ep,ev,re,r,rp)
  if ep==tp or not Duel.IsExistingMatchingCard(c99960340.filter1,tp,LOCATION_MZONE,0,1,nil) then return false end
  return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c99960340.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99960340.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end