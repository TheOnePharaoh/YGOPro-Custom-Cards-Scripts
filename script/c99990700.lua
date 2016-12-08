--SAO - Swordland
function c99990700.initial_effect(c)
  c:SetUniqueOnField(1,0,99990700)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --To Deck
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99990700.tdcon)
  e2:SetTarget(c99990700.tdtg)
  e2:SetOperation(c99990700.tdop)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c) 
  e3:SetDescription(aux.Stringid(99990700,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCondition(c99990700.spcon)
  e3:SetTarget(c99990700.sptg)
  e3:SetOperation(c99990700.spop)
  c:RegisterEffect(e3)
end
function c99990700.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99990700.tdfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99990700.ctfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990700.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c99990700.tdfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99990700.tdfilter,tp,LOCATION_REMOVED,0,1,nil) 
  and Duel.IsExistingTarget(c99990700.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local ct=Duel.GetMatchingGroupCount(c99990700.ctfilter,tp,LOCATION_MZONE,0,nil)
  local g=Duel.SelectTarget(tp,c99990700.tdfilter,tp,LOCATION_REMOVED,0,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99990700.pcfilter(c)
  return c:IsCode(99990040)
end
function c99990700.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=g1:Filter(Card.IsRelateToEffect,nil,e)
  if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingTarget(c99990700.pcfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  local g2=Duel.SelectTarget(tp,c99990700.pcfilter,tp,LOCATION_ONFIELD,0,1,1,nil) 
  local tc=g2:GetFirst()
  if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
  tc:AddCounter(0x9999,sg:GetCount())
  end
  end
end
function c99990700.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingTarget(c99990700.pcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99990700.spfilter(c,e,sp)
  return c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c99990700.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990700.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99990700.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if not Duel.IsExistingMatchingCard(c99990700.pcfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990700.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end