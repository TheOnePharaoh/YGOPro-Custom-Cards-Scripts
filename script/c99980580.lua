--HN - Histoire
function c99980580.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980740,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980580)
  e1:SetHintTiming(0,TIMING_END_PHASE)
  e1:SetTarget(c99980580.sptg)
  e1:SetOperation(c99980580.spop)
  c:RegisterEffect(e1) 
end
function c99980580.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99980580.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980580.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99980580.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980580.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
  c:CancelToGrave()
  Duel.Overlay(tc,Group.FromCards(c))
  end
  end
end