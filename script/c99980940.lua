--HN - Reload The Game
function c99980940.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Extra Summon
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
  e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x998))
  c:RegisterEffect(e2)
  --Return to Hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980940,0))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99980940.thtg)
  e3:SetOperation(c99980940.thop)
  c:RegisterEffect(e3)
end
function c99980940.thfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980940.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99980940.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980940.thfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,c99980940.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980940.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  end
end