--DAL - Ruler
function c99970740.initial_effect(c)
  --Cannot Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_SUMMON)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970740,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99970740.spcon)
  c:RegisterEffect(e2)
  --Face-Down + Search
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970740,1))
  e3:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(c99970740.poscon)
  e3:SetTarget(c99970740.postg)
  e3:SetOperation(c99970740.postop)
  c:RegisterEffect(e3)
  --Negate
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970740,3))
  e4:SetCategory(CATEGORY_NEGATE)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_CHAINING)
  e4:SetCountLimit(1)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99970740.negcon)
  e4:SetTarget(c99970740.negtg)
  e4:SetOperation(c99970740.negop)
  c:RegisterEffect(e4)
end
function c99970740.spfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970740.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99970740.spfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c99970740.poscon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970740.posfilter(c)
  return c:IsFaceup() and c:IsCanTurnSet()
end
function c99970740.thfilter(c)
  return c:IsSetCard(0x997) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c99970740.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970740.posfilter,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(c99970740.posfilter,tp,0,LOCATION_MZONE,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99970740.postop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectMatchingCard(tp,c99970740.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
  if g:GetCount()>0 then
  Duel.HintSelection(g)
  if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c99970740.thfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.SelectYesNo(tp,aux.Stringid(99970740,2)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99970740.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
  end
end
function c99970740.negcon(e,tp,eg,ep,ev,re,r,rp)
  return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99970740.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99970740.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
  Duel.SendtoGrave(eg,REASON_EFFECT)
  end
end