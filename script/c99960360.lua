--BRS - Suffering Feast
function c99960360.initial_effect(c)
  --Recover
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960360+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960360.retcost)
  e1:SetTarget(c99960360.rettg)
  e1:SetOperation(c99960360.retop)
  c:RegisterEffect(e1)
  --ATK
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960360.atkcon)
  e2:SetTarget(c99960360.atktg)
  e2:SetOperation(c99960360.atkop)
  c:RegisterEffect(e2)
end
function c99960360.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960360.retfilter(c)
  return c:IsSetCard(0x996)and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99960360.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960360.retfilter(chkc) end
  local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and ct>0
  and Duel.IsExistingTarget(c99960360.retfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960360.retfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99960360.retop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct>0 then
  Duel.BreakEffect()
  Duel.Draw(tp,2,REASON_EFFECT)
  end
end
function c99960360.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960360.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960360.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960360.atkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960360.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99960360.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960360.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(500)
  tc:RegisterEffect(e1)
  Duel.SetLP(tp,Duel.GetLP(tp)-500)
  end
end