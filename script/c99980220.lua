--HN - White Heart
function c99980220.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980220.thcon)
  e1:SetTarget(c99980220.thtg)
  e1:SetOperation(c99980220.thop)
  c:RegisterEffect(e1)
  --Pos & ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980220,0))
  e2:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCost(c99980220.poscost)
  e2:SetTarget(c99980220.postg)
  e2:SetOperation(c99980220.posop)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980220.atkval)
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
  e5:SetValue(c99980220.xyzlimit)
  c:RegisterEffect(e5)
end
function c99980220.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980220.thfilter(c)
  return c:IsCode(99980200) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980220.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980220.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980220.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980220.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980220.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980220.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980220.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99980220.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99980220.posfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980220.posfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c99980220.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99980220.posop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) then
  Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
  if tc:IsPosition(POS_FACEUP_DEFENSE) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc:GetTextDefense()/2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
  end
end
function c99980220.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(Card.IsCode,nil,99980200)*500
end
function c99980220.xyzlimit(e,c)
  if not c then return false end
  return not c:IsSetCard(0x998)
end