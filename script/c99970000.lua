--DAL - Spacequake
function c99970000.initial_effect(c)
  --Special Summon + Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970000,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970000+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970000.sptg)
  e1:SetOperation(c99970000.spop)
  c:RegisterEffect(e1)
end
function c99970000.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970000.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970000.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970000.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
  and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970000,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    local tc=dg:GetFirst()
    if tc:IsRelateToEffect(e) then
      Duel.Destroy(tc,REASON_EFFECT)
    end
  end
  if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
  Duel.BreakEffect()
  c:CancelToGrave()
  Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
  end
end