--DAL - Nightmare
function c99970300.initial_effect(c)
  --Special Summon + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970300,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970300.spcon)
  e1:SetTarget(c99970300.sptg)
  e1:SetOperation(c99970300.spop)
  c:RegisterEffect(e1)
  --Special Summon From Grave
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetOperation(c99970300.ssgop)
  c:RegisterEffect(e2)
end
function c99970300.spcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) 
  and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM or re:GetHandler():IsCode(99970300))
end
function c99970300.spfilter(c,e,tp)
  return c:IsCode(99970300) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970300.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970300.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99970300.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970300.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,tc,e,tp)
  if g:GetCount()<=0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
  if Duel.IsExistingMatchingCard(c99970300.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970300,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970300.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99970300.ssgop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD) then
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970300,2))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetRange(LOCATION_GRAVE)
  e1:SetTarget(c99970300.sptg2)
  e1:SetOperation(c99970300.spop2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  end
end
function c99970300.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99970300.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if e:GetHandler():IsRelateToEffect(e) then
  Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
  end
end