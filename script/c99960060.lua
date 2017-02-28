--BRS - Chariot
function c99960060.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,nil,4,2)
  c:EnableReviveLimit()
 --Attach
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(c99960060.attachcon)
  e1:SetTarget(c99960060.attachtg)
  e1:SetOperation(c99960060.attachop)
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
  --Damage
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_PHASE+PHASE_END)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(c99960060.damcon)
  e4:SetCost(c99960060.damcost)
  e4:SetTarget(c99960060.damtg)
  e4:SetOperation(c99960060.damop)
  c:RegisterEffect(e4)
  --ATK Up
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EFFECT_UPDATE_ATTACK)
  e5:SetValue(c99960060.value)
  c:RegisterEffect(e5)
  --Detached
  local e6=Effect.CreateEffect(c)
  e6:SetCategory(CATEGORY_TODECK)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e6:SetCode(EVENT_TO_GRAVE)
  e6:SetCondition(c99960060.detcon)
  e6:SetTarget(c99960060.dettg)
  e6:SetOperation(c99960060.detop)
  c:RegisterEffect(e6)
end
function c99960060.attachcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x996) and not (e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
  and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and re:GetHandler()==e:GetHandler())
end
function c99960060.attachfilter(c)
  return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960060.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99960060.attachfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960060.attachfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  Duel.SelectTarget(tp,c99960060.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c99960060.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
  Duel.Overlay(c,Group.FromCards(tc))
  end
end
function c99960060.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,700) end
  Duel.PayLPCost(tp,700)
end
function c99960060.spfilter(c,e,tp)
  return c:IsSetCard(0x996) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and not c:IsCode(99960060)
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99960060.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99960060.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960060.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
  if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
  if not Duel.Equip(tp,tc,c,false) then return end
  --Add Equip limit
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetValue(c99960060.eqlimit)
  tc:RegisterEffect(e1)
  end
end
function c99960060.eqlimit(e,c)
  return e:GetOwner()==c
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
function c99960060.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99960060.damfilter(c,tp)
  return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost()
end
function c99960060.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c99960060.damfilter,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c99960060.damfilter,1,1,nil,tp)
  e:SetLabel(g:GetFirst():GetAttack())
  Duel.SendtoGrave(g,REASON_COST)
end
function c99960060.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local dam=e:GetLabel()
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(dam/2)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam/2)
end
function c99960060.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
