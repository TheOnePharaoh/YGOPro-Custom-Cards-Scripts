--OTNN - Break Burst
function c99930180.initial_effect(c)
  --Activate(summon)
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_SPSUMMON)
  e1:SetCountLimit(1,99930180+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99930180.condition)
  e1:SetTarget(c99930180.target)
  e1:SetOperation(c99930180.activate)
  c:RegisterEffect(e1)
end
function c99930180.condition(e,tp,eg,ep,ev,re,r,rp)
  return tp~=ep and Duel.GetCurrentChain()==0
end
function c99930180.filter(c,e,tp)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x993) and c:GetOverlayCount()>2
end
function c99930180.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99930180.filter(chkc,nil,nil) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99930180.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99930180.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c99930180.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
  local og=tc:GetOverlayGroup()
  if og:GetCount()==0 then return end
  if Duel.SendtoGrave(og,REASON_EFFECT)~=0 then
  Duel.NegateSummon(eg)
  Duel.Destroy(eg,REASON_EFFECT)
  local dg=Duel.GetOperatedGroup()
  local tc=dg:GetFirst()
  local atk=0
  while tc do
  local tatk=tc:GetTextAttack()
  if tatk>0 then atk=atk+tatk end
  tc=dg:GetNext()
  end
  Duel.Damage(1-tp,atk/2,REASON_EFFECT)
  end
end