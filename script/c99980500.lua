--HN - CFW Magic
function c99980500.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCondition(c99980500.thcon)
  e1:SetTarget(c99980500.thtg)
  e1:SetOperation(c99980500.thop)
  c:RegisterEffect(e1)
  --Destroy & Damage
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980500,0))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99980500.descost)
  e2:SetTarget(c99980500.destg)
  e2:SetOperation(c99980500.desop)
  c:RegisterEffect(e2)
  --Summon Success
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(c99980500.regcon)
  e3:SetOperation(c99980500.regop)
  c:RegisterEffect(e3)
  --Material Check
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_MATERIAL_CHECK)
  e4:SetValue(c99980500.valcheck)
  e4:SetLabelObject(e3)
  c:RegisterEffect(e4)
end
function c99980500.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99980500.thfilter(c)
  return c:IsCode(99980480) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980500.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99980500.thfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99980500.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99980500.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99980500.thop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end
function c99980500.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980500.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  local atk=g:GetFirst():GetAttack()/2
  if atk<0 then atk=0 end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c99980500.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
  local atk=tc:GetAttack()
  if atk<0 then atk=0 end
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,atk/2,REASON_EFFECT)
  end
  end
end
function c99980500.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980480) then
  e:GetLabelObject():SetLabel(1)
  else
  e:GetLabelObject():SetLabel(0)
  end
end
function c99980500.regcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c99980500.regop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  --ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  e1:SetValue(c99980500.value)
  c:RegisterEffect(e1)
end
function c99980500.atkfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980500.value(e,c)
  local g=Duel.GetMatchingGroup(c99980500.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
  local ct=g:GetClassCount(Card.GetCode)
  return ct*100
end