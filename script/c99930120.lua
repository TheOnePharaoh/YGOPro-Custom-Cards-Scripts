--OTNN - Tails Emergency
function c99930120.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99930120+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99930120.target)
  e1:SetOperation(c99930120.activate)
  c:RegisterEffect(e1)
end
function c99930120.spfilter1(c,e,tp)
  return c:IsRace(RACE_WARRIOR) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  and Duel.IsExistingTarget(c99930120.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetLevel(),e,tp)
end
function c99930120.spfilter2(c,lv,e,tp)
  return c:IsRace(RACE_WARRIOR) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99930120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
  and Duel.IsExistingTarget(c99930120.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) 
  and Duel.IsExistingTarget(c99930120.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
end
  local lvl=0
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g1=Duel.SelectTarget(tp,c99930120.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc1=g1:GetFirst()
  lvl=lvl+tc1:GetOriginalLevel()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g2=Duel.SelectTarget(tp,c99930120.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,tc1,tc1:GetLevel(),e,tp)
  local tc2=g2:GetFirst()
  lvl=lvl+tc2:GetOriginalLevel()
  e:SetLabel(lvl)
  g1:Merge(g2)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c99930120.xyzfilter(c,e,tp)
  return c:IsSetCard(0x993) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99930120.activate(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
  local lvl=e:GetLabel() 
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if g:GetCount()<2 then return end
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  Duel.BreakEffect()
  local xyzg=Duel.GetMatchingGroup(c99930120.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
  if xyzg:GetCount()>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
  if Duel.XyzSummon(tp,xyz,g)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(lvl*100)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  xyz:RegisterEffect(e1)
  end
  end
end