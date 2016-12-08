--HN - HDD Arrival
function c99980660.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,0x1c0)
  e1:SetCountLimit(1,99980660+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99980660.cost)
  e1:SetTarget(c99980660.target)
  e1:SetOperation(c99980660.activate)
  c:RegisterEffect(e1)
end
function c99980660.costfilter(c)
  return c:IsSetCard(0x998) and (c:GetLevel()==3  or c:GetLevel()==4)  and c:IsAbleToGraveAsCost()
end
function c99980660.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980660.costfilter,tp,LOCATION_DECK,0,1,nil) end
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft>2 then ft=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99980660.costfilter,tp,LOCATION_DECK,0,1,ft,nil)
  ct=Duel.SendtoGrave(g,REASON_COST)
  e:SetLabel(ct)
end
function c99980660.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980660.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980660.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c99980660.activate(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()  
  local ct=e:GetLabel()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980660.spfilter,tp,LOCATION_EXTRA,0,1,ct,nil,e,tp)
  if g:GetCount()>0 then
  local tc=g:GetFirst()
  while tc do
  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
  Duel.SpecialSummonComplete()
  end
end