--BRS - XNFE
function c99960480.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960480,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99960480.spcon)
  e1:SetOperation(c99960480.spop)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960480,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99960480.spcon2)
  e2:SetOperation(c99960480.spop2)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetOperation(c99960480.atklimit)
  c:RegisterEffect(e3)
  --To Hand
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetCondition(c99960480.thcon)
  e4:SetTarget(c99960480.thtg)
  e4:SetOperation(c99960480.thop)
  c:RegisterEffect(e4)
end
function c99960480.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960480.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
  return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and Duel.GetLP(tp)>=500 
  and not Duel.IsExistingMatchingCard(c99960480.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99960480.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,500)
end
function c99960480.spcon2(e,tp,eg,ep,ev,re,r,rp,chk)
  return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and Duel.GetLP(tp)>=250 
  and Duel.IsExistingMatchingCard(c99960480.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99960480.spop2(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,250)
end
function c99960480.atklimit(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
function c99960480.thfilter(c)
  return c:IsSetCard(0x9996) and c:IsAbleToHand()
end
function c99960480.thcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x9996)
end
function c99960480.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960480.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99960480.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99960480.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
