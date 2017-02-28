 --BRS - SZZU
function c99960560.initial_effect(c)
  --Recover
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetTarget(c99960560.rectg)
  e1:SetOperation(c99960560.recop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960560,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99960560.sumcost)
  e2:SetTarget(c99960560.sumtg)
  e2:SetOperation(c99960560.sumop)
  c:RegisterEffect(e2)
  --UnEffect
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960560.uneffcon)
  e3:SetTarget(c99960560.unefftg)
  e3:SetOperation(c99960560.uneffop)
  c:RegisterEffect(e3)
end
function c99960560.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  if chk==0 then return ct>0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function c99960560.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(Card.IsType,e:GetHandler():GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)
  Duel.Recover(p,ct*200,REASON_EFFECT)
end
function c99960560.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99960560.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99960560.sumop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
  Duel.SendtoGrave(c,REASON_RULE)
  end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function c99960560.uneffcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960560.unefffilter(c)
  return c:IsFaceup() and c:IsSetCard(0x996) and c:IsType(TYPE_MONSTER)
end
function c99960560.unefftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c99960560.unefffilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960560.unefffilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99960560.unefffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99960560.uneffop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetValue(aux.tgoval)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end