--BRS - Sanity Break
function c99960460.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCondition(c99960460.spcond)
  e1:SetTarget(c99960460.sptg)
  e1:SetOperation(c99960460.spop)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960460.damcon)
  e2:SetTarget(c99960460.damtg)
  e2:SetOperation(c99960460.damop)
  c:RegisterEffect(e2)
end
function c99960460.condfilter(c,tp)
  return c:IsSetCard(0x996) and c:GetRank()==4 and c:IsReason(REASON_BATTLE+REASON_EFFECT) 
  and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c99960460.spcond(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99960460.condfilter,1,nil,tp)
end
function c99960460.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetRank()==5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960460.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960460.desfilter(c,atk)
  return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c99960460.spop(e,tp,eg,ep,ev,re,r,rp) 
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960460.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local tc=g:GetFirst()
  local dg=Duel.GetMatchingGroup(c99960460.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
  if dg:GetCount()>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local dg=Duel.SelectMatchingCard(tp,c99960460.desfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
  Duel.Destroy(dg,REASON_EFFECT)
  end
  end
end
function c99960460.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960460.damfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER)
end
function c99960460.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960460.damfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960460.damfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99960460.damfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960460.damop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetOperation(c99960460.desop)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1,true)
  end
end
function c99960460.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99960460)
  local atk=e:GetHandler():GetAttack()
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
  Duel.Damage(tp,atk/2,REASON_EFFECT,true)
  Duel.Damage(1-tp,atk/2,REASON_EFFECT,true)
  Duel.RDComplete()
  end  
end
