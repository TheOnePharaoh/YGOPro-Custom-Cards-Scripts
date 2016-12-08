--HN - White Sisters
function c99980280.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980280.thcon)
  e1:SetTarget(c99980280.thtg)
  e1:SetOperation(c99980280.thop)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980280,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99980280.thcost)
  e2:SetTarget(c99980280.thtg2)
  e2:SetOperation(c99980280.thop2)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980280.atkval)
  c:RegisterEffect(e3)
end
function c99980280.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980280.thfilter(c)
  return c:IsCode(99980260) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980280.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980280.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980280.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980280.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980280.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980280.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980280.thfilter2(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()  and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980280.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980280.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99980280.thop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980280.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99980280.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980260)*300
end