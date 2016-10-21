--MSMM - Tomoe Mami
function c99950081.initial_effect(c)
  c:EnableReviveLimit()
  --Spell Zone
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_SEND_REPLACE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(c99950081.sztg)
  e1:SetOperation(c99950081.szop)
  c:RegisterEffect(e1)
  --Pay
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950081.paycon)
  e2:SetOperation(c99950081.payop)
  c:RegisterEffect(e2)
  --ATK up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99950081.value)
  c:RegisterEffect(e3)
  --Direct/Draw
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950081,2))
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCost(c99950081.dircost)
  e4:SetTarget(c99950081.dirtg)
  e4:SetOperation(c99950081.dirop)
  c:RegisterEffect(e4)
  --To hand
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99950081,3))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950081.thcost)
  e5:SetTarget(c99950081.thtg)
  e5:SetOperation(c99950081.thop)
  c:RegisterEffect(e5)
  --Cannot Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_SPSUMMON_CONDITION)
  e6:SetValue(c99950081.splimit)
  c:RegisterEffect(e6)
  --Banish
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_REMOVE)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetCondition(c99950081.bancon)
  e7:SetTarget(c99950081.bantg)
  e7:SetOperation(c99950081.banop)
  c:RegisterEffect(e7)
end
function c99950081.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950081.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
  return Duel.SelectYesNo(tp,aux.Stringid(99950081,0))
end
function c99950081.szop(e,tp,eg,ep,ev,re,r,rp,chk)
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
  --Discard
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950081.discon)
  e2:SetTarget(c99950081.distg)
  e2:SetOperation(c99950081.disop)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950081.discon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0
end
function c99950081.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
end
function c99950081.disop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
  if g:GetCount()>0 then
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950081,4))
  local sg=g:Select(p,1,1,nil)
  Duel.ConfirmCards(tp,sg)
  local tc=sg:GetFirst()
  if tc:IsType(TYPE_MONSTER) then
  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_DISCARD)
  Duel.ShuffleHand(1-tp)
  else Duel.ShuffleHand(1-tp) end 
  end
end
function c99950081.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950081.payop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(99950081,1)) then
  Duel.PayLPCost(tp,300)
  else
  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
  end
end
function c99950081.dirfilter(c)
  return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c99950081.dircost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99950081.dirtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950081.dirfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950081,5))
  Duel.SelectTarget(tp,c99950081.dirfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99950081.dirop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DIRECT_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_BATTLE_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCondition(c99950081.drcon)
  e2:SetTarget(c99950081.drtg)
  e2:SetOperation(c99950081.drop)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  end
end
function c99950081.drcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetAttackTarget()==nil
end
function c99950081.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99950081.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
function c99950081.thfilter(c)
  return c:GetCode()==99950000 and c:IsAbleToHand()
end
function c99950081.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950081.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950081.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950081.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c99950081.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end
function c99950081.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950081.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT)
end
function c99950081.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950081.banfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950081.banfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950081.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950081.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end
function c99950081.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950081.value(e,c)
  return Duel.GetMatchingGroupCount(c99950081.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end