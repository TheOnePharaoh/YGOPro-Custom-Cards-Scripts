--DAL - Date Alive
function c99970640.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Special summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970640,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99970640.spcost)
  e2:SetTarget(c99970640.sptg)
  e2:SetOperation(c99970640.spop)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970640,1))
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(c99970640.spcon)
  e3:SetTarget(c99970640.sptg2)
  e3:SetOperation(c99970640.spop2)
  c:RegisterEffect(e3)
end 
function c99970640.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99970640.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970640.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970640.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970640.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970640.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99970640.cfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970640.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99970640.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99970640.spfilter2(c,e,tp)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970640.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970640.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c99970640.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970640.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end