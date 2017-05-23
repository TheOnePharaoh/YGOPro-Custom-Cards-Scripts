--DAL - Angel
function c99970760.initial_effect(c)
  --Special Summon + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970760,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970760.spcon)
  e1:SetTarget(c99970760.sptg)
  e1:SetOperation(c99970760.spop)
  c:RegisterEffect(e1)
  --Negate 
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970760,2))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCountLimit(1)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c99970760.negcon)
  e2:SetCost(c99970760.negcost)
  e2:SetTarget(c99970760.negtg)
  e2:SetOperation(c99970760.negop)
  c:RegisterEffect(e2)
end
function c99970760.spcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) 
  and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970760.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(99970760)
end
function c99970760.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970760.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970760.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99970760.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99970760.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99970760.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
  if Duel.IsExistingMatchingCard(c99970760.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970760,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970760.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99970760.negcon(e,tp,eg,ep,ev,re,r,rp)
  local rc=re:GetHandler()
  return rp~=tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99970760.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetLabelObject(c)
  e1:SetCountLimit(1)
  e1:SetOperation(c99970760.retop)
  Duel.RegisterEffect(e1,tp)
  end
end
function c99970760.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99970760.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99970760.retop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ReturnToField(e:GetLabelObject())
end