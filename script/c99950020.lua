--MSMM - Kaname Madoka
function c99950020.initial_effect(c)
  c:EnableReviveLimit()
  --Spell Zone
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_SEND_REPLACE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(c99950020.sztg)
  e1:SetOperation(c99950020.szop)
  c:RegisterEffect(e1)
  --Pay Lp
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950020.paycon)
  e2:SetOperation(c99950020.payop)
  c:RegisterEffect(e2)
  --Atk up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99950020.value)
  c:RegisterEffect(e3)
  --DMG/ATK Down
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950020,2))
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTarget(c99950020.damtg)
  e4:SetOperation(c99950020.damop)
  c:RegisterEffect(e4)
  --To Hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950020,3))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950020.thcost)
  e5:SetTarget(c99950020.thtg)
  e5:SetOperation(c99950020.thop)
  c:RegisterEffect(e5)
  --Cannot Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_SPSUMMON_CONDITION)
  e6:SetValue(c99950020.splimit)
  c:RegisterEffect(e6)
  --Banish
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_REMOVE)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetCondition(c99950020.bancon)
  e7:SetTarget(c99950020.bantg)
  e7:SetOperation(c99950020.banop)
  c:RegisterEffect(e7)
end
function c99950020.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950020.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
  return Duel.SelectYesNo(tp,aux.Stringid(99950020,0))
end
function c99950020.szop(e,tp,eg,ep,ev,re,r,rp,chk)
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
  --Recover
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_REMOVE)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(c99950020.reccon)
  e2:SetTarget(c99950020.rectg)
  e2:SetOperation(c99950020.recop)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950020.filter1(c,tp)
  return c:IsType(TYPE_MONSTER) and c:GetPreviousControler()~=tp
end
function c99950020.filter2(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950020.reccon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99950020.filter1,1,nil,tp)
end
function c99950020.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(500)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c99950020.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end
function c99950020.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950020.payop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(99950020,1)) then
  Duel.PayLPCost(tp,300)
  else
  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
  end
end
function c99950020.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0 end
  Duel.SetTargetPlayer(1-tp)
  local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*500
  Duel.SetTargetParam(dam)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99950020.damop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dam=Duel.GetFieldGroupCount(p,LOCATION_MZONE,0)*500
  if Duel.Damage(p,dam,REASON_EFFECT)~=0 then
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-dam)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENCE)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
  end
end
function c99950020.thfilter(c)
  return c:GetCode()==99950000 and c:IsAbleToHand()
end
function c99950020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950020.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950020.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local tg=Duel.GetFirstMatchingCard(c99950020.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end
function c99950020.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950020.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT)
end
function c99950020.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950020.banfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950020.banfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950020.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950020.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end
function c99950020.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950020.value(e,c)
  return Duel.GetMatchingGroupCount(c99950020.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end