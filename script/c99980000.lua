--HN - Neptune
function c99980000.initial_effect(c)
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99980000.thtg)
  e1:SetOperation(c99980000.thop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --Lvl 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(4)
  c:RegisterEffect(e3)
end
function c99980000.thfilter(c)
  return c:IsCode(99980040) and c:IsAbleToHand()
end
function c99980000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980000.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980000.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c99980000.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end