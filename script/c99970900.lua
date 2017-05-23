--DAL - Arusu Maria
function c99970900.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970900,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetTarget(c99970900.sptg1)
  e1:SetOperation(c99970900.spop1)
  c:RegisterEffect(e1)
  --Pendulum Set
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970900,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCondition(c99970900.pscon)
  e2:SetTarget(c99970900.pstg)
  e2:SetOperation(c99970900.psop)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970900,2))
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_SPSUMMON_PROC)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e3:SetRange(LOCATION_HAND)
  e3:SetCountLimit(1)
  e3:SetCondition(c99970900.spcon)
  e3:SetOperation(c99970900.spop2)
  c:RegisterEffect(e3)
  --To Hand
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970900,3))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_PHASE+PHASE_END)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99970900.thcon)
  e4:SetCost(c99970900.thcost)
  e4:SetTarget(c99970900.thtg)
  e4:SetOperation(c99970900.thop)
  c:RegisterEffect(e4)
  --To Pendulum Zone
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99970900,4))
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e5:SetRange(LOCATION_EXTRA)
  e5:SetCountLimit(1)
  e5:SetCondition(c99970900.pzcon)
  e5:SetTarget(c99970900.pztg)
  e5:SetOperation(c99970900.pzop)
  c:RegisterEffect(e5)
end
function c99970900.spfilter(c,e,tp)
  return c:IsCode(99970920) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c99970900.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970900.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c99970900.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970900.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99970900.cpsfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970900.pscon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingTarget(c99970900.cpsfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970900.psfilter(c)
  return c:IsCode(99970920) and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() 
  and c:IsLocation(LOCATION_EXTRA))) and not c:IsForbidden()
end
function c99970900.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDestructable()
  and Duel.IsExistingMatchingCard(c99970900.psfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c99970900.psop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c99970900.psfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
  local tc=g:GetFirst()
  if tc then
  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
  end
end
function c99970900.spcfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c99970900.spcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99970900.spcfilter,tp,LOCATION_HAND,0,1,nil)
end
function c99970900.spop2(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
  local g=Duel.SelectMatchingCard(tp,c99970900.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
  Duel.ConfirmCards(1-tp,g)
  Duel.ShuffleHand(tp)
end
function c99970900.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsReleasable() end
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c99970900.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970900.thfilter1(c)
  return c:IsCode(99970920) and c:IsAbleToHand()
end
function c99970900.thfilter2(c)
  return c:IsCode(99970000) and c:IsAbleToHand()
end
function c99970900.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970900.thfilter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970900.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970900.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  if Duel.IsExistingMatchingCard(c99970900.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970900,5)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99970900.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
  end
end
function c99970900.pzcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970900.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970900.pzop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end