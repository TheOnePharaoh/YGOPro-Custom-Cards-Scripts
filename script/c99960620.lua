--Chains Of Agonizing Fate
function c99960620.initial_effect(c)
  --Excavate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960620+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960620.excacost)
  e1:SetCondition(c99960620.excacon)
  e1:SetTarget(c99960620.excatg)
  e1:SetOperation(c99960620.excaop)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960620.descon)
  e2:SetTarget(c99960620.destg)
  e2:SetOperation(c99960620.desop)
  c:RegisterEffect(e2)
end
function c99960620.excacost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960620.excafilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:GetRank()==5 and c:IsType(TYPE_XYZ)
end
function c99960620.excacon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99960620.excafilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99960620.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
end
function c99960620.tgtg(c,e,tp)
  return c:IsType(TYPE_MONSTER)
end
function c99960620.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960620.excaop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct=Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
  Duel.ConfirmDecktop(1-tp,ct)
  local g1=Duel.GetDecktopGroup(1-tp,ct):Filter(c99960620.tgtg,nil,e,tp)
  if g1:GetCount()>0 then
  local dam=0
  local tc1=g1:GetFirst()
  while tc1 do
  if Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 then
  dam=dam+1
  end
  tc1=g1:GetNext()
  end
  if dam>0 then
  local dam2=Duel.Damage(1-tp,dam*300,REASON_EFFECT)
  if dam2>0 then
  local g2=Duel.GetMatchingGroup(c99960620.atkfilter,tp,LOCATION_MZONE,0,nil)
  local tc2=g2:GetFirst()
  while tc2 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(dam2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  tc2=g2:GetNext()
  end	
  end
  end
  end
end
function c99960620.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960620.desfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960620.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960620.desfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960620.desfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99960620.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960620.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetLabelObject(tc)
  e1:SetCondition(c99960620.descon2)
  e1:SetOperation(c99960620.desop2)
  Duel.RegisterEffect(e1,tp)
end
function c99960620.descon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c99960620.desop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:IsFaceup() then
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
  local ct=Duel.Destroy(sg,REASON_EFFECT)
  if ct>0 then
  Duel.Recover(tp,ct*300,REASON_EFFECT)
  end
  else
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  local ct=Duel.Destroy(sg,REASON_EFFECT)
  if ct>0 then
  Duel.Recover(tp,ct*300,REASON_EFFECT)
  end
  end
end