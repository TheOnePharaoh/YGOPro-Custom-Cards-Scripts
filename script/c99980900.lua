--HN - Next White
function c99980900.initial_effect(c)
  --Xyz summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),5,2)
  c:EnableReviveLimit()
  --Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99980900.xyzcon)
  e1:SetOperation(c99980900.xyzop)
  c:RegisterEffect(e1)
  --To Hand/Extra
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99980900.thcon)
  e2:SetTarget(c99980900.thtg)
  e2:SetOperation(c99980900.thop)
  c:RegisterEffect(e2)
  --Pos & ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980900,0))
  e3:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99980900.poscost)
  e3:SetTarget(c99980900.postg)
  e3:SetOperation(c99980900.posop)
  c:RegisterEffect(e3)
  --Cannot Target
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetCondition(c99980900.cticon)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  --Indes Effect
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99980900.cticon)
  e5:SetValue(c99980900.indval)
  c:RegisterEffect(e5)
  --ATK Up
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_UPDATE_ATTACK)
  e6:SetValue(c99980900.atkval)
  c:RegisterEffect(e6)
end
function c99980900.xyzfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c99980900.xyzcon(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetOverlayCount()
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and Duel.IsExistingTarget(c99980900.xyzfilter,tp,0,LOCATION_ONFIELD,1,nil) and ct>0
end
function c99980900.xyzop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct=e:GetHandler():GetOverlayCount()
  local g=Duel.GetMatchingGroup(c99980900.xyzfilter,tp,0,LOCATION_ONFIELD,nil)
  if ct>0 and g:GetCount()>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local dg=g:Select(tp,1,ct,nil)
  Duel.HintSelection(dg)
  Duel.Destroy(dg,REASON_EFFECT)
  end
end
function c99980900.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980900.thfilter(c)
  return c:IsCode(99980200) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980900.tdfilter(c)
  return c:IsCode(99980220) and c:IsAbleToExtra() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980900.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return Duel.IsExistingTarget(c99980900.thfilter,tp,LOCATION_GRAVE,0,1,nil)
  or Duel.IsExistingTarget(c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  if Duel.IsExistingTarget(c99980900.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=1 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99980900.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
  elseif Duel.IsExistingTarget(c99980900.thfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingTarget(c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=2 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99980900.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
  elseif Duel.IsExistingTarget(c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingTarget(c99980900.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
  v=3 e:SetLabel(v)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99980900.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
  end
end
function c99980900.thop(e,tp,eg,ep,ev,re,r,rp)
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
function c99980900.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980900.posfilter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99980900.posfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980900.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99980900.posfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980900.posfilter1,tp,0,LOCATION_MZONE,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99980900.posfilter2,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c99980900.posfilter1,tp,0,LOCATION_MZONE,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c99980900.posop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
  local atk=0
  local tc=g:GetFirst()
  while tc do
  if tc:IsPosition(POS_FACEUP_DEFENSE) then
  atk=atk+(tc:GetTextDefense()/2)
  end
  tc=g:GetNext()
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
end
function c99980900.cticon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99980220)
end
function c99980900.indval(e,re,tp)
  return tp~=e:GetHandlerPlayer()
end
function c99980900.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980220)*500
end