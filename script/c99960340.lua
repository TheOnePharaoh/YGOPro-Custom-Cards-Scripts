--BRS - Counter Star
function c99960340.initial_effect(c)
  --Negate Attack
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99960340.negcon1)
  e1:SetTarget(c99960340.negtg1)
  e1:SetOperation(c99960340.negop1)
  c:RegisterEffect(e1)
  --Negate Effect
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCondition(c99960340.negcon2)
  e2:SetTarget(c99960340.negtg2)
  e2:SetOperation(c99960340.negop2)
  c:RegisterEffect(e2)
  --Set
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960340.setcon)
  e3:SetTarget(c99960340.settg)
  e3:SetOperation(c99960340.setop)
  c:RegisterEffect(e3)
end
function c99960340.cfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996)
end
function c99960340.negcon1(e,tp,eg,ep,ev,re,r,rp)
  return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c99960340.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99960340.negtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tg=Duel.GetAttacker()
  if chkc then return chkc==tg end
  if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
  Duel.SetTargetCard(tg)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c99960340.negop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() then
  if Duel.NegateAttack(tc) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
  end
end
function c99960340.negcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960340.cfilter,tp,LOCATION_MZONE,0,1,nil)
  and rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99960340.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99960340.negop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99960340.setcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960340.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsSSetable() end
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c99960340.setop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsSSetable() then 
  Duel.SSet(tp,c)
  Duel.ConfirmCards(1-tp,c)
  end
end