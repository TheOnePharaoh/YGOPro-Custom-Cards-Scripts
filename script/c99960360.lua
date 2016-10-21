--BRS - Suffering Feast
function c99960360.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960360,0))
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960360+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99960360.rettg)
  e1:SetOperation(c99960360.retop)
  c:RegisterEffect(e1)
end
function c99960360.retfilter(c)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960360.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960360.retfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960360.retfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960360.retfilter,tp,LOCATION_GRAVE,0,1,99,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*300)
end
function c99960360.retop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
  if ct>0 then
  Duel.Recover(tp,ct*300,REASON_EFFECT)
  Duel.BreakEffect()
  Duel.Draw(tp,2,REASON_EFFECT)
  end
end