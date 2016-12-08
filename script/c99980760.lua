--HN - Fragment Reaction
function c99980760.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980760,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99980760.dettg)
  e1:SetOperation(c99980760.detop)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980760,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1)
  e2:SetCondition(aux.exccon)
  e2:SetTarget(c99980760.tgtg)
  e2:SetOperation(c99980760.tgop)
  c:RegisterEffect(e2)
end
function c99980760.detfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c99980760.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980760.detfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99980760.detfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c99980760.detop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
  local og=tc:GetOverlayGroup()
  if og:GetCount()==0 then return end
  if tc:RemoveOverlayCard(tp,1,99,REASON_EFFECT)~=0 then
  local ct=Duel.GetOperatedGroup():GetCount()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(ct*500)
  tc:RegisterEffect(e1)
  end
end
function c99980760.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c99980760.tgop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
  local sg=g:RandomSelect(tp,1)
  Duel.SendtoGrave(sg,REASON_EFFECT)
end