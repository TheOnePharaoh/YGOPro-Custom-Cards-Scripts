--DAL - Eden's Flares
function c99970880.initial_effect(c)
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_DAMAGE)
  e1:SetCountLimit(1,99970880+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99970880.damcon)
  e1:SetTarget(c99970880.damtg)
  e1:SetOperation(c99970880.damop)
  c:RegisterEffect(e1)
end
function c99970880.damcon(e,tp,eg,ep,ev,re,r,rp)
  return ep==tp
end
function c99970880.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER)
end
function c99970880.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970880.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970880.filter1,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.IsExistingMatchingCard(c99970880.filter2,tp,LOCATION_MZONE,0,2,nil) then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970880.damop(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  local ct1=Duel.GetMatchingGroupCount(c99970880.filter1,tp,LOCATION_MZONE,0,nil)
  local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  if v==1 then 
  local ct3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
  Duel.Damage(1-tp,ct1*300+ct2*500+ct3*300,REASON_EFFECT)
  else
  Duel.Damage(1-tp,ct1*300+ct2*500,REASON_EFFECT)  
  end
end