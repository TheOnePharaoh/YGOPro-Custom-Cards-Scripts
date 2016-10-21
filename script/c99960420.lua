--BRS - Star Of Twisted Chains
function c99960420.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960420)
  e1:SetTarget(c99960420.target)
  e1:SetOperation(c99960420.activate)
  c:RegisterEffect(e1)
end
function c99960420.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER)
end
function c99960420.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960420.filter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960420.filter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960420,2))
  local g=Duel.SelectTarget(tp,c99960420.filter1,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99960420.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local atk=tc:GetTextAttack()
  local op=Duel.SelectOption(tp,aux.Stringid(99960420,0),aux.Stringid(99960420,1))
  if op==0 then
  Duel.Recover(tp,atk,REASON_EFFECT)
  else
  Duel.Damage(1-tp,atk,REASON_EFFECT)
  end
  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
  end
end