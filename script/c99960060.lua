--BRS - Chariot
function c99960060.initial_effect(c)
  c:SetUniqueOnField(1,0,99960060)
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
  e1:SetCondition(c99960060.matcon)
  e1:SetTarget(c99960060.mattg)
  e1:SetOperation(c99960060.matop)
  c:RegisterEffect(e1)
  --Special Summon 1 BRS
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960060,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCost(c99960060.spcost)
  e2:SetTarget(c99960060.sptg)
  e2:SetOperation(c99960060.spop)
  c:RegisterEffect(e2)
  --Equip  
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99960060,1))
  e3:SetCategory(CATEGORY_EQUIP)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99960060.eqcost)
  e3:SetTarget(c99960060.eqtg)
  e3:SetOperation(c99960060.eqop)
  c:RegisterEffect(e3)
  --ATK Up
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99960060.value)
  c:RegisterEffect(e4)
  --Detach
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e5:SetCode(EVENT_TO_GRAVE)
  e5:SetCondition(c99960060.detcon)
  e5:SetTarget(c99960060.dettg)
  e5:SetOperation(c99960060.detop)
  c:RegisterEffect(e5)
end
function c99960060.matcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+9996
end
function c99960060.matfilter(c)
  return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960060.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960060.matfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960060.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960060,2))
  local g=Duel.SelectTarget(tp,c99960060.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99960060.matop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  local og=c:GetOverlayGroup()
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960060.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960060.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.GetLP(tp)>=250 and Duel.IsExistingMatchingCard(c99960060.fildfilter,tp,LOCATION_ONFIELD,0,1,nil))
  or (Duel.GetLP(tp)>=500 and not Duel.IsExistingMatchingCard(c99960060.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
  if Duel.IsExistingMatchingCard(c99960060.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
  Duel.PayLPCost(tp,250)
  elseif not Duel.IsExistingMatchingCard(c99960060.fildfilter,tp,LOCATION_ONFIELD,0,1,nil) then
  Duel.PayLPCost(tp,500)
  end
end
function c99960060.spfilter(c,e,tp)
  return c:IsSetCard(0x9996) and c:IsType(TYPE_XYZ) and c:IsRankBelow(4) and c:IsCanBeSpecialSummoned(e,9996,tp,false,false)
end
function c99960060.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960060.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960060.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960060.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,9996,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960060.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99960060.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c99960060.eqop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  if c:IsFaceup() and c:IsRelateToEffect(e) then
  if not Duel.Equip(tp,tc,c,false) then return end
  --Add Equip limit
  tc:RegisterFlagEffect(99960060,RESET_EVENT+0x1fe0000,0,0)
  e:SetLabelObject(tc)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(c99960060.eqlimit)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
  e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  e2:SetValue(c99960060.repval)
  tc:RegisterEffect(e2)
  end
  end
end
function c99960060.eqlimit(e,c)
  return e:GetOwner()==c and not c:IsDisabled()
end
function c99960060.repval(e,re,r,rp)
  return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c99960060.value(e,c)
  return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end
function c99960060.detcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c99960060.dettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c99960060.detop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
  end
end