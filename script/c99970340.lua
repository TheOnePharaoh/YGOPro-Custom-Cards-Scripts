--DAL - Temporal Selves
function c99970340.initial_effect(c)
  Duel.EnableGlobalFlag(GLOBALFLAG_DELAYED_QUICKEFFECT)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetTarget(c99970340.target)
  e1:SetOperation(c99970340.activate)
  c:RegisterEffect(e1)
end
function c99970340.filter(c,e,tp)
  return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
  and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE))
  and c:IsSetCard(9997) and c:IsLevelAbove(5) and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND)
  and Duel.IsExistingMatchingCard(c99970340.filter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode(),e,tp) 
end
function c99970340.filter2(c,code,e,tp)
  return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) 
end
function c99970340.thfilter(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970340.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return eg:IsContains(chkc) and c99970340.filter(chkc,e,tp) end
  if chk==0 then return eg:IsExists(c99970340.filter,1,nil,e,tp) end
  local v=0
  if Duel.IsExistingTarget(c99970340.thfilter,tp,LOCATION_MZONE,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(99970340,0)) then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=eg:FilterSelect(tp,c99970340.filter,1,1,nil,e,tp)
  Duel.SetTargetCard(g)
end
function c99970340.activate(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  if ft<=0 then return end
  local c=e:GetHandler()
  if ft>3 then ft=3 end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  local tc=Duel.GetFirstTarget()
  local v=e:GetLabel()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99970340.filter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,tc:GetCode(),e,tp)
  if g:GetCount()>0 then
  local tc=g:GetFirst()
  while tc do
  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e1,true)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetCode(EFFECT_CANNOT_TRIGGER)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e2,true)
  if v==1 then
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetCountLimit(1)
  e3:SetOperation(c99970340.thop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e3,true)
  else 
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetCountLimit(1)
  e3:SetOperation(c99970340.tdop)
  e3:SetReset(RESET_EVENT+0x1fe0000)
  tc:RegisterEffect(e3,true)
  end
  tc=g:GetNext()
  end
  Duel.SpecialSummonComplete()
  end
  end
end
function c99970340.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c99970340.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end