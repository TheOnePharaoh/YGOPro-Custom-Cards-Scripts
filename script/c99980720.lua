--HN - Candidate's Training
function c99980720.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99980720.target)
  e1:SetOperation(c99980720.operation)
  c:RegisterEffect(e1)
end
function c99980720.matfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c99980720.matfilter2(c)
  return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x998) and (c:GetLevel()==3 or c:GetLevel()==4) 
end
function c99980720.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99980720.matfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980720.matfilter1,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99980720.matfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99980720.matfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99980720.operation(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=Duel.SelectMatchingCard(tp,c99980720.matfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  if g:GetCount()>0 and Duel.Overlay(tc,g)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(tc:GetOverlayCount()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
  end
end