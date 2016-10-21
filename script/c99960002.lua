--BRS - Black ★ Rock Shooter
function c99960002.initial_effect(c)
  c:SetUniqueOnField(1,0,99960000)
  --Xyz Summon
  aux.AddXyzProcedure(c,nil,4,2)
  c:EnableReviveLimit()
 --Attach
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCountLimit(1)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c99960002.matcon)
  e1:SetTarget(c99960002.mattg)
  e1:SetOperation(c99960002.matop)
  c:RegisterEffect(e1)
  --Special Summon 1 BRS
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960002,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99960002.spcost)
  e2:SetTarget(c99960002.sptg)
  e2:SetOperation(c99960002.spop)
  c:RegisterEffect(e2)
  --Destroy+Damage
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960002,1))
  e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(c99960002.descost)
  e3:SetTarget(c99960002.destg)
  e3:SetOperation(c99960002.desop)
  c:RegisterEffect(e3)
  --ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99960002.value)
  c:RegisterEffect(e4)
  --Detach
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_TODECK)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetCode(EVENT_TO_GRAVE)
  e5:SetCondition(c99960002.detcon)
  e5:SetTarget(c99960002.dettg)
  e5:SetOperation(c99960002.detop)
  c:RegisterEffect(e5)
end
function c99960002.matcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+9996
end
function c99960002.matfilter(c)
  return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960002.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960002.matfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960002.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960002,2))
  local g=Duel.SelectTarget(tp,c99960002.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99960002.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  local og=c:GetOverlayGroup()
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960002.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.GetLP(tp)>=250 and Duel.IsExistingMatchingCard(c99960002.fildfilter,tp,LOCATION_ONFIELD,0,1,nil))
  or (Duel.GetLP(tp)>=500 and not Duel.IsExistingMatchingCard(c99960002.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
  if Duel.IsExistingMatchingCard(c99960002.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
  Duel.PayLPCost(tp,250)
  elseif not Duel.IsExistingMatchingCard(c99960002.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  Duel.PayLPCost(tp,500)
  end
end
function c99960002.spfilter(c,e,tp)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and c:IsCanBeSpecialSummoned(e,9996,tp,false,false)
end
function c99960002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960002.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,9996,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960002.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960002.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp)  then
  if tc:IsType(TYPE_XYZ) then
  local rk=tc:GetRank()
  dmg=rk*200
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  end
  elseif not tc:IsType(TYPE_XYZ) then
  local lvl=tc:GetLevel()
  dmg=lvl*200
  if Duel.Destroy(tc,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  end
  end
  end
end
function c99960002.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end
function c99960002.detcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c99960002.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99960002.detop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
  end
end