--BRS - Sanity Break
function c99960460.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCondition(c99960460.condition)
  e1:SetTarget(c99960460.target)
  e1:SetOperation(c99960460.operation)
  c:RegisterEffect(e1)
end
function c99960460.filter1(c,tp)
  return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
  and c:GetRank()==4 and c:IsSetCard(0x9996)
end
function c99960460.condition(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99960460.filter1,1,nil,tp)
end
function c99960460.filter(c,e,tp)
  return c:IsSetCard(0x9996) and c:GetRank()==5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960460.filter2(c,atk)
  return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsDestructable()
end
function c99960460.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960460.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99960460.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960460.operation(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local dg=Duel.SelectMatchingCard(tp,c99960460.filter2,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack(),tp)
  Duel.Destroy(dg,REASON_EFFECT)
  end
end