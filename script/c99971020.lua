--DAL - Spirit Summon
function c99971020.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99971020,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99971020+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99971020.target)
  e1:SetOperation(c99971020.operation)
  c:RegisterEffect(e1)
end
function c99971020.filter1(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsDiscardable(REASON_EFFECT)
end
function c99971020.filter2(c,e,tp)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99971020.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99971020.filter1,tp,LOCATION_HAND,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99971020.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99971020.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()  
  local g=Duel.GetMatchingGroup(c99971020.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
  local ct=g:GetClassCount(Card.GetCode)
  if ct>2 then ct=2 end
  local rt=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if rt>2 then rt=2 end
  if ct==1 then rt=1 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then rt=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
  local cg=Duel.SelectMatchingCard(tp,c99971020.filter1,tp,LOCATION_HAND,0,1,rt,nil)
  if Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)~=0 then
    local ct1=cg:GetCount()
    if ct1==0 then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local g=Duel.GetMatchingGroup(c99971020.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
    if ct1>g:GetClassCount(Card.GetCode) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=g:Select(tp,1,1,nil)
    if ct1==2 then
      g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g2=g:Select(tp,1,1,nil)
      g1:Merge(g2)
    end
    local tc=g1:GetFirst()
    while tc do
      Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CANNOT_ATTACK)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
      tc=g1:GetNext()
    end
    Duel.SpecialSummonComplete()
  end
end