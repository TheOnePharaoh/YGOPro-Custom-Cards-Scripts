 --BRS - LLWO
function c99960540.initial_effect(c)
  --Discard
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_HANDES)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetTarget(c99960540.distg)
  e1:SetOperation(c99960540.disop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960540,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c99960540.sumcost)
  e2:SetTarget(c99960540.sumtg)
  e2:SetOperation(c99960540.sumop)
  c:RegisterEffect(e2)
  --To Grave
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetCondition(c99960540.descon)
  e3:SetTarget(c99960540.destg)
  e3:SetOperation(c99960540.desop)
  c:RegisterEffect(e3)
end
function c99960540.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99960540.disop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
  local sg=g:RandomSelect(1-tp,1)
  Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c99960540.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,500) end
  Duel.PayLPCost(tp,500)
end
function c99960540.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99960540.sumop(e,tp,eg,ep,ev,re,r,rp)
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
function c99960540.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x996)
end
function c99960540.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99960540.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c99960540.desfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960540.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99960540.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99960540.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end