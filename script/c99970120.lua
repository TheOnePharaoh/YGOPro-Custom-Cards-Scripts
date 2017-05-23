--DAL - Hermit
function c99970120.initial_effect(c)
  --Position + DEF = 0 + To Hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970120,0))
  e1:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970120.poscon)
  e1:SetTarget(c99970120.postg)
  e1:SetOperation(c99970120.posop)
  c:RegisterEffect(e1)
  --Cannot Be Battle Target
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  e2:SetCondition(c99970120.atkcon)
  e2:SetValue(aux.imval1)
  c:RegisterEffect(e2)
end
function c99970120.poscon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970120.posfilter(c)
  return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99970120.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970120.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c99970120.posfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970120.posfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
  local g=Duel.SelectTarget(tp,c99970120.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99970120.posop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)==0 then return end
  --DEF = 0
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e1:SetValue(0)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  if Duel.IsExistingMatchingCard(c99970120.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970120,1)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99970120.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
  end
end
function c99970120.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970120.atkcon(e)
  return Duel.IsExistingMatchingCard(c99970120.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end