--OTNN - Tail Gear Change
function c99930160.initial_effect(c)
  c:SetUniqueOnField(1,0,99930160)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Xyz SUmmon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99930160,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_SZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetHintTiming(TIMING_DAMAGE_STEP)
  e2:SetCountLimit(1)
  e2:SetTarget(c99930160.sptg)
  e2:SetOperation(c99930160.spop)
  c:RegisterEffect(e2)
  --To Deck
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99930160.tdcon)
  e3:SetTarget(c99930160.tdtg)
  e3:SetOperation(c99930160.tdop)
  c:RegisterEffect(e3)
end
function c99930160.filter1(c,e,tp)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x993)
  and Duel.IsExistingMatchingCard(c99930160.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
end
function c99930160.filter2(c,e,tp,mc,code)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x993) and not c:IsCode(code) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99930160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99930160.filter1(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
  and Duel.IsExistingTarget(c99930160.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99930160.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99930160.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99930160.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
  local sc=g:GetFirst()
  if sc then
  local mg=tc:GetOverlayGroup()
  if mg:GetCount()~=0 then
  Duel.Overlay(sc,mg)
  end
  sc:SetMaterial(Group.FromCards(tc))
  Duel.Overlay(sc,Group.FromCards(tc))
  Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
  sc:CompleteProcedure()
  local ct=sc:GetOverlayCount()
  if not sc:IsFaceup() or not sc:IsRelateToEffect(e) and ct<0 then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_RANK)
  e1:SetValue(ct)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  sc:RegisterEffect(e1)
  end
end
function c99930160.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_DESTROY)
end
function c99930160.tdfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x993) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c99930160.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local g=Duel.GetMatchingGroup(c99930160.tdfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  e:SetLabel(g:GetCount())
end
function c99930160.tdop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local ct=e:GetLabel()
  local g=Duel.GetMatchingGroup(c99930160.tdfilter,tp,LOCATION_GRAVE,0,nil)
  if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
  Duel.Draw(tp,ct,REASON_EFFECT)
  end
end