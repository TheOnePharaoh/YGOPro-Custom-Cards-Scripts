--MSMM - Sakura Kyouko
function c99950101.initial_effect(c)
  c:EnableReviveLimit()
  --Spell Zone
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_SEND_REPLACE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTarget(c99950101.sztg)
  e1:SetOperation(c99950101.szop)
  c:RegisterEffect(e1)
  --Pay
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950101.paycon)
  e2:SetOperation(c99950101.payop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99950101.value)
  c:RegisterEffect(e3)
  --Damage/ATK
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950101,2))
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_MZONE)
  e4:SetTarget(c99950101.damtg)
  e4:SetOperation(c99950101.damop)
  c:RegisterEffect(e4)
  --To Hand
  local e5=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99950101,3))
  e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_HAND)
  e5:SetCost(c99950101.thcost)
  e5:SetTarget(c99950101.thtg)
  e5:SetOperation(c99950101.thop)
  c:RegisterEffect(e5)
  --Cannot Special Summon
  local e6=Effect.CreateEffect(c)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_SPSUMMON_CONDITION)
  e6:SetValue(c99950101.splimit)
  c:RegisterEffect(e6)
  --Banish
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_REMOVE)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetCondition(c99950101.bancon)
  e7:SetTarget(c99950101.bantg)
  e7:SetOperation(c99950101.banop)
  c:RegisterEffect(e7)
end
function c99950101.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950101.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
  return Duel.SelectYesNo(tp,aux.Stringid(99950101,0))
end
function c99950101.szop(e,tp,eg,ep,ev,re,r,rp,chk)
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
  --Battle Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetCondition(c99950101.bdcon)
  e2:SetTarget(c99950101.bdtg)
  e2:SetOperation(c99950101.bdop)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950101.bdcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local bc=tc:GetBattleTarget()
  return tc:IsReason(REASON_BATTLE) and bc:IsRelateToBattle() and bc:IsControler(tp) and bc:IsSetCard(9995)
end
function c99950101.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(500)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99950101.bdop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function c99950101.paycon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99950101.payop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLP(tp)>300 and Duel.SelectYesNo(tp,aux.Stringid(99950101,1)) then
  Duel.PayLPCost(tp,300)
  else
  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
  end
end
function c99950101.filter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c99950101.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9995) and c:IsType(TYPE_MONSTER)
end
function c99950101.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950101.filter1,tp,0,LOCATION_REMOVED,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99950101.filter1,tp,0,LOCATION_REMOVED,nil)
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(ct*200)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c99950101.damop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(c99950101.filter1,tp,0,LOCATION_REMOVED,nil)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dmg=ct*200
  if Duel.Damage(p,dmg,REASON_EFFECT)~=0 and Duel.IsExistingTarget(c99950101.filter2,tp,LOCATION_MZONE,0,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950101,4))
  local g=Duel.SelectTarget(tp,c99950101.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  local tc=g:GetFirst()
  if tc:IsRelateToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(dmg)
  tc:RegisterEffect(e1)
  end
  end
end
function c99950101.thfilter(c)
  return c:GetCode()==99950000 and c:IsAbleToHand()
end
function c99950101.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99950101.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99950101.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99950101.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  local tg=Duel.GetFirstMatchingCard(c99950101.thfilter,tp,LOCATION_DECK,0,nil)
  if tg then
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tg)
  end
end
function c99950101.banfilter(c)
  return c:IsFaceup() and c:IsAbleToRemove()
end
function c99950101.bancon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT)
end
function c99950101.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99950101.banfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950101.banfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c99950101.banfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c99950101.banop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
  end
end
function c99950101.value(e,c)
  return Duel.GetMatchingGroupCount(c99950101.filter1,c:GetControler(),0,LOCATION_REMOVED,nil)*100
end