--BRS - Dead Master
function c99960020.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,nil,4,2)
  c:EnableReviveLimit()
 --Attach
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c99960020.attachcon)
  e1:SetTarget(c99960020.attachtg)
  e1:SetOperation(c99960020.attachop)
  c:RegisterEffect(e1)
  --Special Summon 1 BRS
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960020,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99960020.spcost)
  e2:SetTarget(c99960020.sptg)
  e2:SetOperation(c99960020.spop)
  c:RegisterEffect(e2)
  --Special Summon Up To 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960020,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960020.spcost2)
  e3:SetTarget(c99960020.sptg2)
  e3:SetOperation(c99960020.spop2)
  c:RegisterEffect(e3)
  --ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99960020.value)
  c:RegisterEffect(e4)
  --Detached
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_TODECK)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetCode(EVENT_TO_GRAVE)
  e5:SetCondition(c99960020.detcon)
  e5:SetTarget(c99960020.dettg)
  e5:SetOperation(c99960020.detop)
  c:RegisterEffect(e5)
end
function c99960020.attachcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x996) and not (e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
  and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and re:GetHandler()==e:GetHandler())
end
function c99960020.attachfilter(c)
  return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960020.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99960020.attachfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960020.attachfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  Duel.SelectTarget(tp,c99960020.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99960020.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960020.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and not c:IsCode(99960020)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960020.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960020.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960020.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960020.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960020.spfilter2(c,e,tp)
  return c:IsLevelBelow(4) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960020.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960020.spfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99960020.spop2(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  if ft>2 then ft=2 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960020.spfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ft,nil,e,tp)
  if g:GetCount()~=0 then
  local atk=0
  local tc=g:GetFirst()
  while tc do
  atk= atk + tc:GetBaseAttack()/2
  tc=g:GetNext()
  end
  if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
  end
end
function c99960020.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end
function c99960020.detcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c99960020.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99960020.detop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
  end
end