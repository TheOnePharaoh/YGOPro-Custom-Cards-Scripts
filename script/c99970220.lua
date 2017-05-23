--DAL - CR-unit - Origami
function c99970220.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x997),3,2)
  c:EnableReviveLimit()
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99970220.atkval)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970220,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(c99970220.thtg)
  e2:SetOperation(c99970220.thop)
  c:RegisterEffect(e2)
  --Destroy
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970220,1))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99970220.descon)
  e3:SetTarget(c99970220.destg)
  e3:SetOperation(c99970220.desop)
  c:RegisterEffect(e3)
end
function c99970220.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970220.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970220.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
function c99970220.thfilter(c)
  return c:IsCode(99970240) and c:IsAbleToHand()
end
function c99970220.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970220.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99970220.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970220.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99970220.desfilter(c)
  return c:IsFaceup() and c:IsDestructable() and c:IsAttackBelow(1500)
end
function c99970220.descon(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970220.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970220.desfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970220.desfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970220.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970220.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end