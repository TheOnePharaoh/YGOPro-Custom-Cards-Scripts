--HN - Oramge Heart
function c99980840.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980840.thcon)
  e1:SetTarget(c99980840.thtg)
  e1:SetOperation(c99980840.thop)
  c:RegisterEffect(e1)
  --Attach material
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99980840.matcost)
  e2:SetTarget(c99980840.mattg)
  e2:SetOperation(c99980840.matop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980840.atkval)
  c:RegisterEffect(e3)
  --Lvl 5 Xyz
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_XYZ_LEVEL)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(5)
  c:RegisterEffect(e4)
  --HN Xyz
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
  e5:SetValue(c99980840.xyzlimit)
  c:RegisterEffect(e5)
end
function c99980840.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980840.thfilter(c)
  return c:IsCode(99980820) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980840.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980840.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980840.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980840.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980840.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980840.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980840.matfilter1(c,e,tp)
  local rk=c:GetRank()
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
  and Duel.IsExistingMatchingCard(c99980840.matfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,rk-1,e,tp)
end
function c99980840.matfilter2(c,rk,e,tp)
  return c:IsSetCard(0x998) and (c:GetRank()==rk or c:GetLevel()==rk)
end
function c99980840.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99980840.matfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980840.matfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99980840.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c99980840.matop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
  local rk=tc:GetRank()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=Duel.SelectMatchingCard(tp,c99980840.matfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,rk-1,e,tp)
  if g:GetCount()>0 then
  Duel.Overlay(tc,g)
  end
  end
end
function c99980840.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980820)*500
end
function c99980840.xyzlimit(e,c)
  if not c then return false end
  return not c:IsSetCard(0x998)
end