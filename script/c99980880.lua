--HN - Gamindustri MK2
function c99980880.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99980880.accon)
  c:RegisterEffect(e1)
  --Indes
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCondition(c99980880.indcon)
  e2:SetValue(c99980880.tgvalue)
  c:RegisterEffect(e2)
  --cannot be target
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCondition(c99980880.indcon)
  e3:SetValue(aux.tgoval)
  c:RegisterEffect(e3)
  --ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetRange(LOCATION_FZONE)
  e4:SetTargetRange(LOCATION_MZONE,0)
  e4:SetTarget(c99980880.atktg)
  e4:SetValue(1000)
  c:RegisterEffect(e4)
  --Negate
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e5:SetType(EFFECT_TYPE_QUICK_O)
  e5:SetCode(EVENT_CHAINING)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e5:SetCountLimit(1)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCondition(c99980880.negcon)
  e5:SetTarget(c99980880.negtg)
  e5:SetOperation(c99980880.negop)
  c:RegisterEffect(e5)
  --Return to Deck
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e6:SetCategory(CATEGORY_TODECK)
  e6:SetCode(EVENT_PHASE+PHASE_END)
  e6:SetRange(LOCATION_SZONE)
  e6:SetCountLimit(1)
  e6:SetCondition(c99980880.tdcon)
  e6:SetTarget(c99980880.tdtg)
  e6:SetOperation(c99980880.tdop)
  c:RegisterEffect(e6)
end
function c99980880.accon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsEnvironment(99980860,tp)
end
function c99980880.infilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980880.tgvalue(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
function c99980880.indcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99980880.infilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99980880.atktg(e,c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980880.negcon(e,tp,eg,ep,ev,re,r,rp)
  if ep==tp or not Duel.IsExistingMatchingCard(c99980880.infilter,tp,LOCATION_MZONE,0,1,nil) then return false end
  return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c99980880.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99980880.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99980880.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return tp==Duel.GetTurnPlayer()
end
function c99980880.tdfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980880.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsLocation(tp) and c99980880.tdfilter(chkc,e,tp,lv,true) end
  if chk==0 then return Duel.IsExistingTarget(c99980880.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99980880.tdfilter,tp,LOCATION_GRAVE,0,1,2,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99980880.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=g:Filter(Card.IsRelateToEffect,nil,e)
  if sg:GetCount()>0 then
  Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
  end
end