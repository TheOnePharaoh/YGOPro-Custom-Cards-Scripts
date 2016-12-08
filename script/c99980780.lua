--HN - Next Black
function c99980780.initial_effect(c)
  --Xyz summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),5,2)
  c:EnableReviveLimit()
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99980780.xyzcon)
  e1:SetTarget(c99980780.xyztg)
  e1:SetOperation(c99980780.xyzop)
  c:RegisterEffect(e1)
  --To Hand/Extra
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99980780.thcon)
  e2:SetTarget(c99980780.thtg)
  e2:SetOperation(c99980780.thop)
  c:RegisterEffect(e2)
  --Piercing Damage
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980780,0))
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99980780.pdcost)
  e3:SetTarget(c99980780.pdtg)
  e3:SetOperation(c99980780.pdop)
  c:RegisterEffect(e3)
  --Cannot Target
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetCondition(c99980780.cticon)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  --Indes Effect
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99980780.cticon)
  e5:SetValue(c99980780.indval)
  c:RegisterEffect(e5)
  --ATK Up
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_UPDATE_ATTACK)
  e6:SetValue(c99980780.atkval)
  c:RegisterEffect(e6)
end
function c99980780.xyzcon(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetOverlayCount()
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and ct>0
end
function c99980780.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ct=e:GetHandler():GetOverlayCount()
  Duel.SetTargetPlayer(1-tp)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c99980780.xyzop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=c:GetOverlayCount()
  Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c99980780.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980780.thfilter(c)
  return c:IsCode(99980100) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980780.tdfilter(c)
  return c:IsCode(99980120) and c:IsAbleToExtra() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980780.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return Duel.IsExistingTarget(c99980780.thfilter,tp,LOCATION_GRAVE,0,1,nil)
  or Duel.IsExistingTarget(c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  if Duel.IsExistingTarget(c99980780.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=1 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99980780.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
  elseif Duel.IsExistingTarget(c99980780.thfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingTarget(c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=2 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99980780.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  elseif Duel.IsExistingTarget(c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingTarget(c99980780.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=3 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99980780.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
  end
end
function c99980780.thop(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel() 
  if v==1 then
  local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
  local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
  local th=g1:Filter(Card.IsRelateToEffect,nil,e)
  Duel.SendtoHand(th,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,th)
  local td=g2:Filter(Card.IsRelateToEffect,nil,e)
  Duel.SendtoDeck(td,nil,0,REASON_EFFECT)
  elseif v==2 then
  local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
  local th=g1:Filter(Card.IsRelateToEffect,nil,e)
  Duel.SendtoHand(th,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,th)
  elseif v==3 then
  local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
  local td=g2:Filter(Card.IsRelateToEffect,nil,e)
  Duel.SendtoDeck(td,nil,0,REASON_EFFECT)
  end
end
function c99980780.pdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980780.pdfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980780.pdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980780.pdfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c99980780.pdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99980780.pdfilter,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_PIERCE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetCategory(EFFECT_UPDATE_ATTACK)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_CONFIRM)
  e2:SetTarget(c99980780.atktg)
  e2:SetOperation(c99980780.atkop)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
end
function c99980780.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980780.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  local t=Duel.GetAttackTarget()
  if chk ==0 then return Duel.IsExistingMatchingCard(c99980020.atkfilter,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() end
end
function c99980780.atkop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99980780.atkfilter,tp,LOCATION_MZONE,0,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
end
function c99980780.cticon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99980120)
end
function c99980780.indval(e,re,tp)
  return tp~=e:GetHandlerPlayer()
end
function c99980780.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980120)*500
end