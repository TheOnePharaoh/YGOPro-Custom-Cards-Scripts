--DAL - Pool Party
function c99970580.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99970580.condition)
  e1:SetTarget(c99970580.target)
  e1:SetOperation(c99970580.operation)
  c:RegisterEffect(e1)
end
function c99970580.filter1(c)
  return c:IsFaceup() and c:IsCode(99970520)
end
function c99970580.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99970580.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function c99970580.filter2(c,e,tp)
  return c:IsSetCard(9997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970580.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970580.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970580.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970580.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_BP)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
  e1:SetTargetRange(0,1)
  Duel.RegisterEffect(e1,tp)
  end
end