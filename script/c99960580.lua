--BRS - Star Burst Forbearance
function c99960580.initial_effect(c)
  --material
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960580+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99960580.target)
  e1:SetOperation(c99960580.operation)
  c:RegisterEffect(e1)
end
function c99960580.filter1(c)
  return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsFaceup()
end
function c99960580.filter2(c)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9996)
end
function c99960580.spfilter(c,e,tp)
  return c:GetRank()==4 and c:IsSetCard(0x9996) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960580.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99960580.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960580.filter1,tp,0,LOCATION_MZONE,1,nil)
  and Duel.IsExistingMatchingCard(c99960580.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c99960580.operation(e,tp,eg,ep,ev,re,r,rp) 
  local c=e:GetHandler()           
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960580,0))
  local g1=Duel.SelectTarget(tp,c99960580.filter1,tp,0,LOCATION_MZONE,1,1,nil)
  local tc1=g1:GetFirst()
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960580,1))
  local g2=Duel.SelectTarget(tp,c99960580.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  local tc2=g2:GetFirst()
  if tc2:IsRelateToEffect(e) and tc1:IsRelateToEffect(e) and not tc1:IsImmuneToEffect(e) then
  local og=tc1:GetOverlayGroup()
  if og:GetCount()>0 then
  Duel.SendtoGrave(og,REASON_RULE)
  end
  Duel.Overlay(tc2,tc1)
  if tc1:IsType(TYPE_XYZ) then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc1:GetRank()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  else
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc1:GetLevel()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  end
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DAMAGE_STEP_END)
  e2:SetCondition(c99960580.spcon)
  e2:SetTarget(c99960580.sptg)
  e2:SetOperation(c99960580.spop)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e2)
  end
end
function c99960580.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler()==Duel.GetAttacker()
end
function c99960580.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c99960580.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99960580.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99960580.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99960580.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SpecialSummon(tc,9996,tp,tp,false,false,POS_FACEUP)
  end
end