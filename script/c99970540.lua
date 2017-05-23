--DAL - Diva
function c99970540.initial_effect(c)
  --Contol + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970540,0))
  e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970540.ctcon)
  e1:SetTarget(c99970540.cttg)
  e1:SetOperation(c99970540.ctop)
  c:RegisterEffect(e1)
  --ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970540,2))
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99970540.atktg)
  e2:SetOperation(c99970540.atkop)
  c:RegisterEffect(e2)
end
function c99970540.ctcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970540.ctfilter(c)
  return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c99970540.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970540.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970540.ctfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970540.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
  local g=Duel.SelectTarget(tp,c99970540.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c99970540.ctop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or not tc:IsFaceup() or Duel.GetControl(tc,tp,PHASE_END,1)==0 then return end
  if Duel.IsExistingMatchingCard(c99970540.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970540,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970540.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99970540.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970540.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
  and Duel.IsExistingMatchingCard(c99970540.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970540.atkop(e,tp,eg,ep,ev,re,r,rp)
  local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local g2=Duel.GetMatchingGroup(c99970540.atkfilter,tp,LOCATION_MZONE,0,nil)
  if g1:GetCount()>0 and g2:GetCount()>0 then
  local atk=g2:GetCount()*200
  local sc1=g1:GetFirst()
  while sc1 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(-atk)
  sc1:RegisterEffect(e1)
  sc1=g1:GetNext()
  end
  local sc2=g2:GetFirst()
  while sc2 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(atk)
  sc2:RegisterEffect(e1)
  sc2=g2:GetNext()
  end
  end
end