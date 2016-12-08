--HN - Lowee
function c99980240.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980240.descon)
  e2:SetTarget(c99980240.destg)
  e2:SetOperation(c99980240.desop)
  c:RegisterEffect(e2)
  --To Hand
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCondition(c99980240.thcon)
  e3:SetTarget(c99980240.thtg)
  e3:SetOperation(c99980240.thop)
  c:RegisterEffect(e3)
end
function c99980240.desfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99980240.descon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980240.desfilter1,1,nil,tp)
end
function c99980240.desfilter2(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99980240.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c99980240.desfilter2(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980240.desfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99980240.desfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99980240.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end
function c99980240.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980240.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980240.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980240.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980240.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980240.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end