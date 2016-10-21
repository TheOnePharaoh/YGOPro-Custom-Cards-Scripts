--BRS - LLWO
function c99960540.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99960540,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99960540.spcon)
  e1:SetOperation(c99960540.spop)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99960540,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99960540.spcon2)
  e2:SetOperation(c99960540.spop2)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetOperation(c99960540.atklimit)
  c:RegisterEffect(e3)
  --Destroy
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetCondition(c99960540.descon)
  e4:SetTarget(c99960540.destg)
  e4:SetOperation(c99960540.desop)
  c:RegisterEffect(e4)
end
function c99960540.fildfilter(c)
  return c:IsFaceup() and c:IsCode(99960300)
end
function c99960540.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
  return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and Duel.GetLP(tp)>=500 
  and not Duel.IsExistingMatchingCard(c99960540.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99960540.spop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,500)
end
function c99960540.spcon2(e,tp,eg,ep,ev,re,r,rp,chk)
  return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and Duel.GetLP(tp)>=250 
  and Duel.IsExistingMatchingCard(c99960540.fildfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99960540.spop2(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.PayLPCost(tp,250)
end
function c99960540.atklimit(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
end
function c99960540.desfilter(c)
  return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99960540.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
  and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x9996)
end
function c99960540.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and c99960540.desfilter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(c99960540.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99960540.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99960540.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.Destroy(tc,REASON_EFFECT)
  end
end