--DAL - Efreet
function c99970080.initial_effect(c)
  --Destroy + To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970080,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970080.descon)
  e1:SetTarget(c99970080.destg)
  e1:SetOperation(c99970080.desop)
  c:RegisterEffect(e1)
  --Indestructable
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e2:SetCountLimit(1)
  e2:SetValue(c99970080.valcon)
  c:RegisterEffect(e2)
end
function c99970080.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970080.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970080.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970080.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
  if Duel.IsExistingMatchingCard(c99970080.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970080,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99970080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
function c99970080.valcon(e,re,r,rp)
  return bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0  and rp~=e:GetHandlerPlayer())
end