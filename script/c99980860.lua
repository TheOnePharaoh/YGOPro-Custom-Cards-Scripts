--HN - Gamindustri
function c99980860.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99980860.accost)
  c:RegisterEffect(e1)
  --Indes
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(c99980860.indcon)
  e2:SetValue(c99980860.tgvalue)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetRange(LOCATION_FZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(c99980860.atktg)
  e3:SetValue(700)
  c:RegisterEffect(e3)
  --Negate
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_CHAINING)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_FZONE)
  e4:SetCondition(c99980860.negcon)
  e4:SetTarget(c99980860.negtg)
  e4:SetOperation(c99980860.negop)
  c:RegisterEffect(e4)
  --Return to Deck
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e5:SetCategory(CATEGORY_TODECK)
  e5:SetCode(EVENT_PHASE+PHASE_END)
  e5:SetRange(LOCATION_SZONE)
  e5:SetCountLimit(1)
  e5:SetCondition(c99980860.tdcon)
  e5:SetTarget(c99980860.tdtg)
  e5:SetOperation(c99980860.tdop)
  c:RegisterEffect(e5)
end
function c99980860.acfilter(c,code)
  return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c99980860.accost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,99980040)
  and Duel.IsExistingMatchingCard(c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,99980140)
  and Duel.IsExistingMatchingCard(c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,99980240)
  and Duel.IsExistingMatchingCard(c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,99980340) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g1=Duel.SelectMatchingCard(tp,c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,99980040)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g2=Duel.SelectMatchingCard(tp,c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,99980140)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g3=Duel.SelectMatchingCard(tp,c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,99980240)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g4=Duel.SelectMatchingCard(tp,c99980860.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,99980340)
  g1:Merge(g2)
  g1:Merge(g3)
  g1:Merge(g4)
  Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c99980860.infilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980860.tgvalue(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
function c99980860.indcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99980860.infilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99980860.atktg(e,c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980860.negcon(e,tp,eg,ep,ev,re,r,rp)
  if ep==tp or not Duel.IsExistingMatchingCard(c99980860.infilter,tp,LOCATION_MZONE,0,1,nil) then return false end
  return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c99980860.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99980860.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
end
function c99980860.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return tp==Duel.GetTurnPlayer()
end
function c99980860.tdfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980860.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsLocation(tp) and c99980860.tdfilter(chkc,e,tp,lv,true) end
  if chk==0 then return Duel.IsExistingTarget(c99980860.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99980860.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99980860.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
  end
end