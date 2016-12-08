--HN - Compa
function c99980380.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99980380.sptg)
  e1:SetOperation(c99980380.spop)
  c:RegisterEffect(e1)
  --Lvl 4 Xyz
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_XYZ_LEVEL)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetValue(4)
  c:RegisterEffect(e2)
end
function c99980380.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
  and Duel.IsExistingMatchingCard(c99980380.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c99980380.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980380.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end