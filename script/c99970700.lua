--DAL - Witch
function c99970700.initial_effect(c)
  --ATK/DEF + Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970700,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99970700.atkcon)
  e1:SetTarget(c99970700.atktg)
  e1:SetOperation(c99970700.atkop)
  c:RegisterEffect(e1)
  --Negate Attack
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970700,2))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99970700.negcon)
  e2:SetTarget(c99970700.negtg)
  e2:SetOperation(c99970700.negop)
  c:RegisterEffect(e2)
end
function c99970700.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970700.atkfilter(c,atk)
  return c:IsFaceup() and c:GetAttack()~=atk
end
function c99970700.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970700.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  local atk=c:GetAttack()
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c and c99970700.atkfilter(chkc,atk) end
  if chk==0 then return Duel.IsExistingTarget(c99970700.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,atk) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99970700.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,atk)
end
function c99970700.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local tc=Duel.GetFirstTarget()
  local atk=tc:GetAttack()
  local def=tc:GetDefense()
  if not tc:IsRelateToEffect(e) or not tc:IsFaceup() or not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
  e2:SetValue(def)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  if Duel.IsExistingMatchingCard(c99970700.thfilter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99970700,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970700.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99970700.negcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp)
end
function c99970700.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970700.negop(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  if Duel.NegateAttack() then
  Duel.Damage(1-tp,a:GetAttack(),REASON_EFFECT)
  end
end