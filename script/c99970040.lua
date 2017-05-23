--DAL - Princess
function c99970040.initial_effect(c)
  --Destroy + To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970040,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970040.descon)
  e1:SetTarget(c99970040.destg)
  e1:SetOperation(c99970040.desop)
  c:RegisterEffect(e1)
  --Cannot Activate Spell/Trap
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetOperation(c99970040.atkop)
  c:RegisterEffect(e2)
end
function c99970040.descon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970040.desfilter(c)
  return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970040.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970040.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c99970040.desfilter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(c99970040.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99970040.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970040.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
  if Duel.IsExistingMatchingCard(c99970040.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970040,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99970040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
function c99970040.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetTargetRange(0,1)
  e1:SetValue(c99970040.aclimit)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  Duel.RegisterEffect(e1,tp)
end
function c99970040.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end