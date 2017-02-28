 --BRS - MEFE
function c99960500.initial_effect(c)
  --Mill
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetTarget(c99960500.milltg)
  e1:SetOperation(c99960500.millop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960500,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99960500.sumcost)
  e2:SetTarget(c99960500.sumtg)
  e2:SetOperation(c99960500.sumop)
  c:RegisterEffect(e2)
  --To Hand
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960500.tgcon)
  e3:SetTarget(c99960500.tgtg)
  e3:SetOperation(c99960500.tgop)
  c:RegisterEffect(e3)
end
function c99960500.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,1)
end
function c99960500.millop(e,tp,eg,ep,ev,re,r,rp)
  Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function c99960500.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99960500.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99960500.sumop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
  Duel.SendtoGrave(c,REASON_RULE)
  end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function c99960500.tgfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c99960500.tgcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960500.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960500.tgfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99960500.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99960500.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoGrave(g,REASON_EFFECT)
  end
end