--MSMM - Miki Sayaka
function c99950060.initial_effect(c)
  c:EnableReviveLimit()
  --Spell Zone
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_SEND_REPLACE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(c99950060.sztg)
  e1:SetOperation(c99950060.szop)
  c:RegisterEffect(e1)
  --Pay
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950060.paycon)
  e2:SetOperation(c99950060.payop)
  c:RegisterEffect(e2)
  --ATK up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99950060.value)
  c:RegisterEffect(e3)
  --Attack Twice/ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950060,2))
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTarget(c99950060.twitg)
  e4:SetOperation(c99950060.twiop)
  c:RegisterEffect(e4)
  --To Hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950060,3))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950060.thcost)
  e5:SetTarget(c99950060.thtg)
  e5:SetOperation(c99950060.thop)
  c:RegisterEffect(e5)
  --Cannot Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_SPSUMMON_CONDITION)
  e6:SetValue(c99950060.splimit)
  c:RegisterEffect(e6)
  --Banish
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_REMOVE)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetCondition(c99950060.bancon)
  e7:SetTarget(c99950060.bantg)
  e7:SetOperation(c99950060.banop)
  c:RegisterEffect(e7)
end
function c99950060.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950060.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
  return Duel.SelectYesNo(tp,aux.Stringid(99950060,0))
end
function c99950060.szop(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  --Spell
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_CHANGE_TYPE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fc0000)
  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
  c:RegisterEffect(e1)
  --ATK up
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_SZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(c99950060.autg)
  e2:SetValue(500)
  e2:SetReset(RESET_EVENT+0x1fc0000)
  c:RegisterEffect(e2)
  Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950060.autg(e,c)
  return c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950060.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950060.payop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(99950060,1)) then
  Duel.PayLPCost(tp,300)
  else
  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
  end
end
function c99950060.filter1(c)
  return c:IsSetCard(9995) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end 
function c99950060.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c99950060.twitg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99950060.filter2,tp,LOCATION_MZONE,0,1,nil) and
  Duel.IsExistingMatchingCard(c99950060.filter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99950060.twiop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,c99950060.filter1,tp,LOCATION_DECK,0,1,1,nil)
  if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and Duel.IsExistingTarget(c99950060.filter2,tp,LOCATION_MZONE,0,1,nil) then
  Duel.ShuffleDeck(tp)
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950060,4))
  local g2=Duel.SelectTarget(tp,c99950060.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  local tc=g2:GetFirst()
  if tc:IsRelateToEffect(e) then
  local atk=tc:GetAttack()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EXTRA_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(1)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e2:SetValue(math.ceil(atk/2))
  tc:RegisterEffect(e2)
  end
  end
end
function c99950060.thfilter(c)
  return c:GetCode()==99950000 and c:IsAbleToHand()
end
function c99950060.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950060.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950060.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950060.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c99950060.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end
function c99950060.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950060.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT)
end
function c99950060.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950060.banfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950060.banfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950060.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950060.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end
function c99950060.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950060.value(e,c)
  return Duel.GetMatchingGroupCount(c99950060.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end