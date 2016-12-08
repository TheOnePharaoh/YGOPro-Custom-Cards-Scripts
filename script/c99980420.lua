--HN - Iris Heart
function c99980420.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980420.thcon)
  e1:SetTarget(c99980420.thtg)
  e1:SetOperation(c99980420.thop)
  c:RegisterEffect(e1)
  --ATK/DEF Down
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980420,0))
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99980420.atkcost)
  e2:SetTarget(c99980420.atktg)
  e2:SetOperation(c99980420.atkop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980420.atkval)
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
  e5:SetValue(c99980420.xyzlimit)
  c:RegisterEffect(e5)
end
function c99980420.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980420.thfilter(c)
  return c:IsCode(99980400) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980420.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980420.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980420.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980420.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980420.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980420.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980420.atkfilter(c)
	return c:IsFaceup()
end
function c99980420.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99980420.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c99980420.atkop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99980420.atkfilter,tp,0,LOCATION_MZONE,nil)
  local tc=g:GetFirst()
  while tc do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-500)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  tc:RegisterEffect(e2)
  tc=g:GetNext()
  end
end
function c99980420.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980400)*500
end
function c99980420.xyzlimit(e,c)
  if not c then return false end
  return not c:IsSetCard(0x998)
end