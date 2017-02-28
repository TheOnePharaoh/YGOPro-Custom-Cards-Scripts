--BRS - Star Burst Forbearance
function c99960580.initial_effect(c)
  --material
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99960580.attchtg)
  e1:SetOperation(c99960580.attachop)
  c:RegisterEffect(e1)
  --ATK
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960580.atkcon)
  e2:SetTarget(c99960580.atktg)
  e2:SetOperation(c99960580.atkop)
  c:RegisterEffect(e2)
end
function c99960580.attchfilter1(c)
  return c:IsType(TYPE_MONSTER)
end
function c99960580.attachfilter2(c)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x996)
end
function c99960580.attchtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99960580.attchfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960580.attchfilter1,tp,LOCATION_GRAVE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99960580.attachfilter2,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
  local g=Duel.SelectTarget(tp,c99960580.attchfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99960580.attachop(e,tp,eg,ep,ev,re,r,rp) 
  local c=e:GetHandler()           
  local tc1=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g2=Duel.SelectTarget(tp,c99960580.attachfilter2,tp,LOCATION_MZONE,0,1,1,nil)
  local tc2=g2:GetFirst()
  if tc2:IsRelateToEffect(e) and tc1:IsRelateToEffect(e) then
  Duel.Overlay(tc2,Group.FromCards(tc1))
  end
  if tc1:IsType(TYPE_XYZ) then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc1:GetRank()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  else
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(tc1:GetLevel()*300)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc2:RegisterEffect(e1)
  end
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e2:SetTarget(c99960580.sptg)
  e2:SetOperation(c99960580.spop)
  tc2:RegisterEffect(e2)
end
function c99960580.spfilter(c,e,tp)
  return c:GetRank()==4 and c:IsSetCard(0x996) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99960580.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c99960580.spfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99960580.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99960580.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99960580.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  end
end
function c99960580.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
end
function c99960580.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_XYZ)
end
function c99960580.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960580.atkfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960580.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99960580.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960580.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(Duel.GetMatchingGroupCount(c99960580.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*300)
  tc:RegisterEffect(e1)
  end
end