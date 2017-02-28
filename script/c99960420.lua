--BRS - Star Of Twisted Chains
function c99960420.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960420)
  e1:SetTarget(c99960420.rettg)
  e1:SetOperation(c99960420.retop)
  c:RegisterEffect(e1)
  --Reveal
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960420.revcon)
  e2:SetOperation(c99960420.revop)
  c:RegisterEffect(e2)
end
function c99960420.retfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960420.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960420.retfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960420.retfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960420.retfilter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99960420.retop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local atk=tc:GetAttack()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
  local op=Duel.SelectOption(tp,aux.Stringid(99960420,0),aux.Stringid(99960420,1))
  if op==0 then
  Duel.Recover(tp,atk/2,REASON_EFFECT)
  else
  Duel.Damage(1-tp,atk/2,REASON_EFFECT)
  end
  end
end
function c99960420.revcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
  and Duel.IsPlayerCanDraw(tp,1)
end
function c99960420.revop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
  local tc=Duel.GetOperatedGroup():GetFirst()
  Duel.ConfirmCards(1-tp,tc)
  if tc:IsType(TYPE_MONSTER) then
  local atk=tc:GetAttack()
  local op=Duel.SelectOption(tp,aux.Stringid(99960420,0),aux.Stringid(99960420,1))
  if op==0 then
  Duel.Recover(tp,atk/2,REASON_EFFECT)
  else
  Duel.Damage(1-tp,atk/2,REASON_EFFECT)
  end
  end
  Duel.ShuffleHand(tp)
end