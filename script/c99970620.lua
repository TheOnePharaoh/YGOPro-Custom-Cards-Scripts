--DAL - Berserk
function c99970620.initial_effect(c)
  --Destroy + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970620,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970620.descon)
  e1:SetTarget(c99970620.destg)
  e1:SetOperation(c99970620.desop)
  c:RegisterEffect(e1)
  --Direct Attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_DIRECT_ATTACK)
  e2:SetCondition(c99970620.dircon)
  c:RegisterEffect(e2)
end
function c99970620.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970620.desfilter(c)
  return not c:IsAttackPos() and c:IsDestructable()
end
function c99970620.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970620.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970620.desfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970620.desfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970620.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970620.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
  local def=tc:GetBaseDefense()
  if Duel.Damage(1-tp,def,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c99970620.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970620,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970620.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99970620.dircon(e)
  local tp=e:GetHandlerPlayer()
  return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end