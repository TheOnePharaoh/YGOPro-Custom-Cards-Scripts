-- Insanity Rage
function c99960640.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960640+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960640.cost)
  e1:SetOperation(c99960640.activate)
  c:RegisterEffect(e1)
  --Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960640.revcon)
  e2:SetTarget(c99960640.revtg)
  e2:SetOperation(c99960640.revop)
  c:RegisterEffect(e2)
end
function c99960640.activate(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CHANGE_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99960640.val)
  e1:SetReset(RESET_PHASE+PHASE_END,1)
  Duel.RegisterEffect(e1,tp)
end
function c99960640.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960640.val(e,re,dam,r,rp,rc)
  if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x996) and rp==e:GetHandler():GetControler() then
  return dam*2
  else return dam end
end
function c99960640.revcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960640.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c99960640.revop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  if g:GetCount()==0 then return end
  local sg=g:RandomSelect(tp,1)
  Duel.ConfirmCards(tp,sg)
  Duel.ShuffleHand(1-tp)
  local tc=sg:GetFirst()
  if tc:IsType(TYPE_MONSTER) then
  Duel.Damage(1-tp,500,REASON_EFFECT)
  end
end