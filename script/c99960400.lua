--BRS - Through Anger And Fears
function c99960400.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetTarget(c99960400.sptg)
  e1:SetOperation(c99960400.spop)
  c:RegisterEffect(e1)
  --Damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99960400.damcon)
  e2:SetOperation(c99960400.damop)
  c:RegisterEffect(e2)
end
function c99960400.rtfilter(c,tp)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x996) and c:GetRank()==4 and c:IsAbleToExtra()
end
function c99960400.spfilter(c,e,tp)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x996) and c:GetRank()==5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
  and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99960400.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99960400.rtfilter(chkc,tp) end
  if chk==0 then return Duel.IsExistingMatchingCard(c99960400.rtfilter,tp,LOCATION_MZONE,0,1,nil,tp) 
  and Duel.IsExistingMatchingCard(c99960400.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99960400.rtfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c99960400.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99960400.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
  local tc2=g:GetFirst()
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetValue(1000)
  tc2:RegisterEffect(e1)  
  end
  end
end
function c99960400.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996) 
  and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end
function c99960400.damop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
  Duel.ConfirmDecktop(1-tp,1)
  local g=Duel.GetDecktopGroup(1-tp,1)
  local tc=g:GetFirst()
  if tc:IsType(TYPE_MONSTER) then
  Duel.Damage(1-tp,1000,REASON_EFFECT)
  end
end