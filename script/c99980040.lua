--HN - Planeptune
function c99980040.initial_effect(c)
  c:EnableCounterPermit(0x9998)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Add Counter
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980040.ctcon)
  e2:SetOperation(c99980040.ctop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetRange(LOCATION_SZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(c99980040.atktg)
  e3:SetValue(c99980040.atkval)
  c:RegisterEffect(e3)
  --To Hand
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_LEAVE_FIELD)
  e4:SetCondition(c99980040.thcon)
  e4:SetTarget(c99980040.thtg)
  e4:SetOperation(c99980040.thop)
  c:RegisterEffect(e4)
end
function c99980040.ctfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99980040.ctcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980040.ctfilter,1,nil,tp)
end
function c99980040.ctop(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():AddCounter(0x9998,1)
end
function c99980040.atktg(e,c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) 
end
function c99980040.atkval(e,c)
  return e:GetHandler():GetCounter(0x9998)*200
end
function c99980040.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980040.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980040.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980040.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end