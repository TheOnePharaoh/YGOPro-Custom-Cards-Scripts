--HN - Noire
function c99980100.initial_effect(c)
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetTarget(c99980100.thtg)
  e1:SetOperation(c99980100.thop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  local e3=e1:Clone()
  e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e3)
  --Lvl 4 Xyz
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_XYZ_LEVEL)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(4)
  c:RegisterEffect(e4)
end
function c99980100.thfilter(c)
  return c:IsCode(99980140) and c:IsAbleToHand()
end
function c99980100.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980100.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980100.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c99980100.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end