--DAL - Spirit Summon
function c99971020.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99971020+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99971020.cost)
  e1:SetTarget(c99971020.target)
  e1:SetOperation(c99971020.activate)
  c:RegisterEffect(e1)
end
function c99971020.filter1(c)
  return c:IsSetCard(9997) and c:GetLevel()==3 and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c99971020.filter2(c,e,tp)
  return c:IsSetCard(9997) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99971020.filter3(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99971020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99971020.filter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
  local rt=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if rt>2 then rt=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then rt=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
  local cg=Duel.SelectMatchingCard(tp,c99971020.filter1,tp,LOCATION_HAND,0,1,rt,nil)
  Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
  e:SetLabel(cg:GetCount())
end
function c99971020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99971020.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
end
function c99971020.activate(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()  
  if Duel.GetMatchingGroupCount(c99971020.filter3,tp,LOCATION_MZONE,0,nil)==1 then v=1
  else v=0 end
  local ct1=e:GetLabel()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99971020.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,ct1,nil,e,tp)
  if g:GetCount()>0 then
  if v==1 then
  local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(ct2*300)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
  Duel.SpecialSummonComplete()
  else
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end