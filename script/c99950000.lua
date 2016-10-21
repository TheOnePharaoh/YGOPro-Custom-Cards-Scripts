--MSMM - Let's Make A Contract
function c99950000.initial_effect(c)
  --Ritual
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99950000.target)
  e1:SetOperation(c99950000.operation)
  c:RegisterEffect(e1)
  --To Deck
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(c99950000.tdcon)
  e2:SetCost(c99950000.tdcost)
  e2:SetTarget(c99950000.tdtg)
  e2:SetOperation(c99950000.tdop)
  c:RegisterEffect(e2)
end
function c99950000.filter1(c,e)
  return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c99950000.filter2(c,e,tp,m)
  if bit.band(c:GetType(),0x81)~=0x81 or not (c:IsSetCard(9995) and c:GetLevel()==5)
  or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
  local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
  return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c99950000.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
  local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
  if g:GetSum(Card.GetLevel)<5 then return false end
  end
  local mg1=Duel.GetRitualMaterial(tp)
  mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
  local mg2=Duel.GetMatchingGroup(c99950000.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e)
  mg1:Merge(mg2)
  return Duel.IsExistingMatchingCard(c99950000.filter2,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99950000.operation(e,tp,eg,ep,ev,re,r,rp)
  local mg1=Duel.GetRitualMaterial(tp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
  mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
  local mg2=Duel.GetMatchingGroup(c99950000.filter1,tp,LOCATION_MZONE,0,nil,e)
  mg1:Merge(mg2)
  else 
  local mg2=Duel.GetMatchingGroup(c99950000.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e)
  mg1:Merge(mg2)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local tg=Duel.SelectMatchingCard(tp,c99950000.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
  local tc=tg:GetFirst()
  if tc then
  local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
  local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
  tc:SetMaterial(mat)
  local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
  mat:Sub(mat2)
  Duel.ReleaseRitualMaterial(mat)
  Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
  Duel.BreakEffect()
  Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
  tc:CompleteProcedure()
  end
end
function c99950000.filter3(c,e,tp,m)
  if not (c:IsSetCard(9995) and c:GetLevel()==5) or bit.band(c:GetType(),0x81)~=0x81
  or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
  local mg=m:Filter(Card.IsType,nil,TYPE_MONSTER)
  if c.mat_filter then
  mg=mg:Filter(c.mat_filter,nil)
  end
  return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c99950000.filter4(c,e)
  return c:IsType(TYPE_MONSTER) and c:GetLevel()>=1 and not c:IsImmuneToEffect(e) and c:IsAbleToRemove() 
end
function c99950000.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnCount()~=e:GetHandler():GetTurnID()
end
function c99950000.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99950000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
  local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
  mg:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
  local sg=Duel.GetMatchingGroup(c99950000.filter4,tp,0,LOCATION_GRAVE,nil,e)
  mg:Merge(sg)
  return Duel.IsExistingMatchingCard(c99950000.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c99950000.tdop(e,tp,eg,ep,ev,re,r,rp)
  local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
  mg:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
  local sg=Duel.GetMatchingGroup(c99950000.filter4,tp,0,LOCATION_GRAVE,nil,e)
  mg:Merge(sg)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local tg=Duel.SelectMatchingCard(tp,c99950000.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
  local tc=tg:GetFirst()
  if tc then
  mg=mg:Filter(Card.IsType,nil,TYPE_MONSTER)
  if tc.mat_filter then
  mg=mg:Filter(tc.mat_filter,nil)
  end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
  tc:SetMaterial(mat)
  Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
  Duel.BreakEffect()
  Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
  tc:CompleteProcedure()
  end
end