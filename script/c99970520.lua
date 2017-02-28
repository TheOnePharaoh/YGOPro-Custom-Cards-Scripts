--DAL - The Spirit Summer
function c99970520.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --add counter
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetCondition(c99970520.ctcon)
  e2:SetOperation(c99970520.ctop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_RECOVER)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetCode(EVENT_LEAVE_FIELD)
  e5:SetCondition(c99970520.reccon)
  e5:SetTarget(c99970520.rectg)
  e5:SetOperation(c99970520.recop)
  c:RegisterEffect(e5)
end
function c99970520.ctfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c99970520.ctcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99970520.ctfilter,1,nil,tp) and rp==tp
end
function c99970520.ctop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():AddCounter(0x9997,1)
end
function c99970520.reccon(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetCounter(0x9997)
  e:SetLabel(ct)
  return e:GetHandler():IsReason(REASON_DESTROY) and ct>0
end
function c99970520.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=e:GetLabel()
  if chk==0 then return ct~=0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(ct*300)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function c99970520.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end