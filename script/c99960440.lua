--Hope Beyond Pain
function c99960440.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
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
function c99960440.filter1(c,e,tp)
  return c:IsSetCard(0x9996) and (c:GetRank()==4  or c:GetLevel()==4)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960440.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960440.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960440.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99960440.operation(e,tp,eg,ep,ev,re,r,rp)
local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  local c=e:GetHandler()
  if ft>2 then ft=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960440.filter1,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
  if g:GetCount()>0 then
  local tc=g:GetFirst()
  while tc do
  Duel.SpecialSummonStep(tc,9996,tp,tp,false,false,POS_FACEUP)
  tc=g:GetNext()
  end
  Duel.SpecialSummonComplete()
  end
end
function c99960440.filter2(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9996) 
end
function c99960440.reccon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and bit.band(r,REASON_DISCARD)~=0 
  and Duel.IsExistingMatchingCard(c99960440.filter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c99960440.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99960440.filter2,tp,LOCATION_GRAVE,0,1,nil) end
  local sg=Duel.GetMatchingGroup(c99960440.filter2,tp,LOCATION_GRAVE,0,nil)
  local val=sg:GetCount()*500
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(val)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c99960440.recop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c99960440.filter2,tp,LOCATION_GRAVE,0,nil)
  local val=sg:GetCount()*500
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Recover(p,val,REASON_EFFECT)
end