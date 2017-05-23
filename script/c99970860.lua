--DAL - Inverse Angel - Devil
function c99970860.initial_effect(c)
  c:EnableReviveLimit()
  --Special Summon Rule
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970860,0))
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetCondition(c99970860.hspcon)
  e1:SetOperation(c99970860.hspop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970860,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(c99970860.spcon)
  e2:SetTarget(c99970860.sptg)
  e2:SetOperation(c99970860.spop)
  c:RegisterEffect(e2)
  --Destroy Replace
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_DESTROY_REPLACE)
  e3:SetCountLimit(1)
  e3:SetTarget(c99970860.reptg)
  e3:SetOperation(c99970860.repop)
  c:RegisterEffect(e3)
 --Negate 
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970860,3))
  e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_CHAINING)
  e4:SetCountLimit(1)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99970860.negcon)
  e4:SetCost(c99970860.negcost)
  e4:SetTarget(c99970860.negtg)
  e4:SetOperation(c99970860.negop)
  c:RegisterEffect(e4)
end
function c99970860.hspfilter(c)
  return c:IsFaceup() and c:IsCode(99970760) and c:IsAbleToRemoveAsCost()
end
function c99970860.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
  and Duel.IsExistingMatchingCard(c99970860.hspfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c99970860.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99970860.hspfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99970860.spcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) 
  and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970860.spfilter(c,e,tp)
  return c:IsSetCard(0x997) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(99970860)
end
function c99970860.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970860.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99970860.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99970860.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99970860.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c99970860.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetOwnerPlayer(tp)
    tc:RegisterEffect(e1)
  end
end
function c99970860.efilter(e,re)
  return e:GetOwnerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c99970860.repfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x997) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c99970860.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
  and Duel.IsExistingMatchingCard(c99970860.repfilter,tp,LOCATION_ONFIELD,0,1,c) end
  if Duel.SelectYesNo(tp,aux.Stringid(99970860,2)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
    local g=Duel.SelectMatchingCard(tp,c99970860.repfilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SetTargetCard(g)
    g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
    return true
  else return false end
end
function c99970860.repop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
  Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c99970860.negcon(e,tp,eg,ep,ev,re,r,rp)
  local rc=re:GetHandler()
  return rp~=tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c99970860.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabelObject(c)
    e1:SetCountLimit(1)
    e1:SetOperation(c99970860.retop)
    Duel.RegisterEffect(e1,tp)
  end
end
function c99970860.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99970860.negop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99970860.retop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ReturnToField(e:GetLabelObject())
end