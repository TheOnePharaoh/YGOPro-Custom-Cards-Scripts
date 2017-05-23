--DAL - Honjou Nia
function c99970980.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970980,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_CHAINING)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetCondition(c99970980.spcon)
  e1:SetCost(c99970980.spcost)
  e1:SetTarget(c99970980.sptg)
  e1:SetOperation(c99970980.spop)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970980,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCondition(c99970980.thcon)
  e2:SetTarget(c99970980.thtg)
  e2:SetOperation(c99970980.thop)
  c:RegisterEffect(e2)
end
function c99970980.spcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp
end
function c99970980.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99970980.spfilter(c,e,tp)
  return c:IsCode(99971000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970980.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99970980.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970980.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970980.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99970980.thcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
  and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c99970980.thfilter(c)
  return c:IsCode(99970000) and c:IsAbleToHand()
end
function c99970980.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970980.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99970980.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970980.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end