--Chain Wings Of Hope
function c99960440.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99960440+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99960440.cost)
  e1:SetTarget(c99960440.target)
  e1:SetOperation(c99960440.operation)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960440.reccon)
  e2:SetTarget(c99960440.rectg)
  e2:SetOperation(c99960440.recop)
  c:RegisterEffect(e2)
end
function c99960440.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960440.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:GetLevel()==4
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960440.shfilter(c)
  return c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960440.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960440.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))
  or Duel.IsExistingTarget(c99960440.shfilter,tp,LOCATION_GRAVE,0,1,nil) end
end    
function c99960440.operation(e,tp,eg,ep,ev,re,r,rp)
  Duel.HintSelection(Group.FromCards(c))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960440.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))
  and Duel.IsExistingTarget(c99960440.shfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99960440,0),aux.Stringid(99960440,1))
  elseif (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960440.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))
  and not Duel.IsExistingTarget(c99960440.shfilter,tp,LOCATION_GRAVE,0,1,nil)then
  select=Duel.SelectOption(tp,aux.Stringid(99960440,0))
  elseif Duel.IsExistingTarget(c99960440.shfilter,tp,LOCATION_GRAVE,0,1,nil) then
  select=Duel.SelectOption(tp,aux.Stringid(99960440,1))
  select=1
  end
  if select==0 then
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  if ft>2 then ft=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960440.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  else
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960440.shfilter,tp,LOCATION_GRAVE,0,1,2,nil)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct>0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CHANGE_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  e1:SetValue(0)
  e1:SetReset(RESET_PHASE+PHASE_END,2)
  Duel.RegisterEffect(e1,tp)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
  e2:SetReset(RESET_PHASE+PHASE_END,2)
  Duel.RegisterEffect(e2,tp)
  end
  end
end
function c99960440.recfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x996) 
end
function c99960440.reccon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960440.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960440.recfilter,tp,LOCATION_GRAVE,0,1,nil) end
  local sg=Duel.GetMatchingGroup(c99960440.recfilter,tp,LOCATION_GRAVE,0,nil)
  local val=sg:GetCount()*500
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(val)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c99960440.recop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c99960440.recfilter,tp,LOCATION_GRAVE,0,nil)
  local val=sg:GetCount()*500
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Recover(p,val,REASON_EFFECT)
end