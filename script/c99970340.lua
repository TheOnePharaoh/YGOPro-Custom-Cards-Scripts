--DAL - Temporal Selves
function c99970340.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970340,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,99970340+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970340.sptg)
  e1:SetOperation(c99970340.spop)
  c:RegisterEffect(e1)
  --Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99970340,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99970340.descost)
  e2:SetTarget(c99970340.destg)
  e2:SetOperation(c99970340.desop)
  c:RegisterEffect(e2)
end
function c99970340.spfilter1(c,e,tp)
  return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
  and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsSetCard(0x997) and c:IsLevelAbove(5) and c:IsCanBeEffectTarget(e)
  and Duel.IsExistingMatchingCard(c99970340.spfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode(),e,tp)
  and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function c99970340.spfilter2(c,code,e,tp)
  return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970340.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return eg:IsContains(chkc) and c99970340.spfilter1(chkc,e,tp) end
  if chk==0 then return eg:IsExists(c99970340.spfilter1,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=eg:FilterSelect(tp,c99970340.spfilter1,1,1,nil,e,tp)
  Duel.SetTargetCard(g)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99970340.spop(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  if ft>3 then ft=3 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  local fid=e:GetHandler():GetFieldID()
  local tc=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970340.spfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,tc:GetCode(),e,tp)
  if ft<=0 or g:GetCount()==0 then return end
  local tc=g:GetFirst()
  while tc do
  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_DISABLE_EFFECT)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1)
  tc:RegisterFlagEffect(99970340,RESET_EVENT+0x1fe0000,0,1,fid)
  tc=g:GetNext()
  end
  Duel.SpecialSummonComplete()
  g:KeepAlive()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCountLimit(1)
  e1:SetLabel(fid)
  e1:SetLabelObject(g)
  e1:SetCondition(c99970340.tdcon)
  e1:SetOperation(c99970340.tdop)
  Duel.RegisterEffect(e1,tp)
end
function c99970340.tdfilter(c,fid)
  return c:GetFlagEffectLabel(99970340)==fid
end
function c99970340.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  if not g:IsExists(c99970340.tdfilter,1,nil,e:GetLabel()) then
  g:DeleteGroup()
  e:Reset()
  return false
  else return true end
end
function c99970340.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  local tg=g:Filter(c99970340.tdfilter,nil,e:GetLabel())
  Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
function c99970340.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99970340.desfilter(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x997)
  and Duel.IsExistingMatchingCard(c99970340.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode(),e,tp)
end
function c99970340.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99970340.desfilter(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99970340.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c99970340.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99970340.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970340.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc:GetCode(),e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end