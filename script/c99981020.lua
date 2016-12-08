--HN - Golden Faith Black Heart
function c99981020.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,c99981020.mfilter,5,2,c99981020.ovfilter,aux.Stringid(99981020,2),2,c99981020.xyzop)
  c:EnableReviveLimit()
  --Pendulum Summon
  aux.EnablePendulumAttribute(c,false)
  --Negate 
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99981020.negcon)
  e1:SetTarget(c99981020.negtg)
  e1:SetOperation(c99981020.negop)
  c:RegisterEffect(e1)
  --Pendulum Set
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99981020.pctg)
  e2:SetOperation(c99981020.pcop)
  c:RegisterEffect(e2)
  --Pierce
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e3)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99981020,0))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99981020.atkcost)
  e3:SetTarget(c99981020.atktg)
  e3:SetOperation(c99981020.atkop)
  c:RegisterEffect(e3)
  --Summon Success
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetCondition(c99981020.regcon)
  e4:SetOperation(c99981020.regop)
  c:RegisterEffect(e4)
  --Material Check
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_MATERIAL_CHECK)
  e5:SetValue(c99981020.valcheck)
  e5:SetLabelObject(e4)
  c:RegisterEffect(e5)
  --Pendulum
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_DESTROY)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e6:SetCode(EVENT_DESTROYED)
  e6:SetProperty(EFFECT_FLAG_DELAY)
  e6:SetCondition(c99981020.pencon)
  e6:SetTarget(c99981020.pentg)
  e6:SetOperation(c99981020.penop)
  c:RegisterEffect(e6)
end
function c99981020.mfilter(c)
  return c:IsSetCard(0x998)
end
function c99981020.ovfilter(c)
  return c:IsFaceup() and c:IsCode(99980120)
end
function c99981020.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,99981020)==0 end
end
  c99981020.pendulum_level=5
function c99981020.negfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99981020.negcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99981020.negfilter1,1,nil,tp)
end
function c99981020.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99981020.negop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
  Duel.NegateRelatedChain(tc,RESET_TURN_SET)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EFFECT_DISABLE_EFFECT)
  e2:SetValue(RESET_TURN_SET)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  if tc:IsType(TYPE_TRAPMONSTER) then
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e3)
  end
  end
end
function c99981020.pcfilter(c)
  return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x998) and not c:IsForbidden()
end
function c99981020.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
  local seq=e:GetHandler():GetSequence()
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
  and Duel.IsExistingMatchingCard(c99981020.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c99981020.pcop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local seq=e:GetHandler():GetSequence()
  if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
  local g=Duel.SelectMatchingCard(tp,c99981020.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end
function c99981020.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99981020.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99981020.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99981020.atkfilter,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,ct,nil)
end
function c99981020.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()   
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  local atksum=0
  local tc=g:GetFirst()
  while tc do
  local atk=tc:GetAttack()
  atksum=atksum+math.ceil(atk/2)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(math.ceil(atk/2))
  tc:RegisterEffect(e1)
  tc=g:GetNext()
  end
  if c:IsRelateToEffect(e) and c:IsFaceup() and atksum>0 then
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e2:SetValue(atksum)
  c:RegisterEffect(e2)
  end
end
function c99981020.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980120) then
  e:GetLabelObject():SetLabel(1)
  else
  e:GetLabelObject():SetLabel(0)
  end
end
function c99981020.regcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c99981020.regop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  --Negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99981020,1))
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(c99981020.xyznegcost)
  e1:SetTarget(c99981020.xyznegtg)
  e1:SetOperation(c99981020.xyznegop)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end
function c99981020.xyznegcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99981020.xyznegtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c99981020.xyznegop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_DISABLE_EFFECT)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
end
function c99981020.pencon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c99981020.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c99981020.penop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end