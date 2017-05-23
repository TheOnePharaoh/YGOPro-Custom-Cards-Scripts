--DAL - Force Switch
function c99970400.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970400,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970400.thtg)
  e1:SetOperation(c99970400.thop)
  c:RegisterEffect(e1)
  end
function c99970400.thfilter(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsAbleToHand()
  and ((c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(c99970400.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,c:GetCode()))
  or (c:IsLevelAbove(5) and Duel.IsExistingMatchingCard(c99970400.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,c:GetCode()))
  or (c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c99970400.spfilter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())))
end
function c99970400.spfilter1(c,e,tp,code)
  return c:IsSetCard(0x997) and c:IsLevelBelow(4) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970400.spfilter2(c,e,tp,code)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970400.spfilter3(c,e,tp,code)
  return c:IsSetCard(0x997) and c:IsType(TYPE_XYZ) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970400.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970400.thfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingTarget(c99970400.thfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,c99970400.thfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99970400.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()      
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelBelow(4) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg=Duel.SelectMatchingCard(tp,c99970400.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
  local tc2=sg:GetFirst()
  if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
  Duel.Recover(tp,700,REASON_EFFECT)
  end
  elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(5) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg=Duel.SelectMatchingCard(tp,c99970400.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
  local tc2=sg:GetFirst()
  if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(500)
  tc2:RegisterEffect(e1)
  end
  elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local sg=Duel.SelectMatchingCard(tp,c99970400.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  local tc2=sg:GetFirst()
  if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
  c:CancelToGrave()
  Duel.Overlay(tc2,Group.FromCards(c))
  end
  end
end