--DAL - Eden's Flares
function c99970880.initial_effect(c)
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetCountLimit(1,99970880+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99970880.accon)
  e1:SetOperation(c99970880.acop)
  c:RegisterEffect(e1)
end
function c99970880.acfilter(c,tp)
  return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) 
  and c:IsSetCard(0x997) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
end
function c99970880.accon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99970880.acfilter,1,nil,tp)
end
function c99970880.acop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99970880,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetReset(RESET_PHASE+PHASE_END)
  e1:SetCountLimit(1)
  e1:SetTarget(c99970880.destg)
  e1:SetOperation(c99970880.desop)
  Duel.RegisterEffect(e1,tp)
end
function c99970880.desfilter(c)
  return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99970880.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970880.desfilter,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(c99970880.desfilter,tp,0,LOCATION_MZONE,nil)
  Duel.Hint(HINT_CARD,0,99970880)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c99970880.damfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970880.desop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99970880.desfilter,tp,0,LOCATION_MZONE,nil)
  local dam=Duel.GetMatchingGroupCount(c99970880.damfilter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
  if Duel.Destroy(g,REASON_EFFECT)~=0 and dam>0 then
  Duel.Damage(1-tp,dam,REASON_EFFECT)
  end
end