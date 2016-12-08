--SAO - Illusion Incantation
function c99990600.initial_effect(c)
  --ATK Up
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99990600.atkcost1)
  e1:SetTarget(c99990600.atktg)
  e1:SetOperation(c99990600.atkop)
  c:RegisterEffect(e1)
  --ATK Up
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990600,0))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99990600.atkcost2)
  e2:SetTarget(c99990600.atktg)
  e2:SetOperation(c99990600.atkop)
  c:RegisterEffect(e2)
end
function c99990600.tgfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) 
end
function c99990600.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990600.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990600.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetAttack())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990600.atkfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999)
end
function c99990600.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99990600.atkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99990600.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99990600.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990600.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
  local atk=e:GetLabel()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk/2)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end
function c99990600.banfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990600.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
  and Duel.IsExistingMatchingCard(c99990600.banfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990600.banfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  e:SetLabel(g:GetFirst():GetAttack())
  g:AddCard(e:GetHandler())
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end