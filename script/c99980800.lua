--HN - Transcending Shares
function c99980800.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980800+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980800.target)
  e1:SetOperation(c99980800.activate)
  c:RegisterEffect(e1)
end
function c99980800.tdfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980800.tdfilter2(c)
  return c:IsSetCard(0x998) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99980800.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetAttackedCount()>0
end
function c99980800.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
  and Duel.IsExistingMatchingCard(c99980800.tdfilter1,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99980800.tdfilter2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980800.activate(e,tp,eg,ep,ev,re,r,rp)
  local g1=Duel.GetMatchingGroup(c99980800.tdfilter1,tp,LOCATION_MZONE,0,nil)
  local val=g1:GetCount()
  local g2=Duel.GetMatchingGroup(c99980800.tdfilter2,tp,LOCATION_GRAVE,0,nil)
  if g2:GetCount()<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local sg=g2:Select(tp,1,val,nil)
  Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
  local og=Duel.GetOperatedGroup()
  if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
  if ct>=1 then
  Duel.BreakEffect()
  Duel.Draw(tp,1,REASON_EFFECT)
  local g3=Duel.GetMatchingGroup(c99980800.recfilter,tp,LOCATION_MZONE,0,nil)
  local rec=g3:GetCount()
  if rec>0 then
  Duel.Recover(tp,500*rec,REASON_EFFECT)
  end
  end
end