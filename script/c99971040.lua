--DAL - Date's Guard
function c99971040.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99971040,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99971040.cost)
  e1:SetTarget(c99971040.target)
  e1:SetOperation(c99971040.activate)
  c:RegisterEffect(e1)
  --Act In Hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetCondition(c99971040.handcon)
  c:RegisterEffect(e2)
end
function c99971040.cfilter(c)
  return c:IsCode(99970160) and c:IsAbleToRemoveAsCost()
end
function c99971040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99971040.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99971040.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  local tg=g:GetFirst()
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetRange(LOCATION_REMOVED)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99971040.tdcon)
  e1:SetOperation(c99971040.tdop)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
  tg:RegisterEffect(e1)
end
function c99971040.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99971040.tdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c99971040.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99971040.activate(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetTargetRange(LOCATION_SZONE,0)
  e1:SetTarget(c99971040.indtg)
  e1:SetValue(c99971040.indval)
  e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
  Duel.RegisterEffect(e1,tp)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetValue(aux.tgoval)
  Duel.RegisterEffect(e2,tp)
end
function c99971040.indtg(e,c)
  return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x997)
end
function c99971040.indval(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
function c99971040.handcon(e)
  local tp=e:GetHandlerPlayer()
  local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
  local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
  return (tc1 and tc1:IsSetCard(0x997) and (tc1:GetLeftScale()==1 or tc1:GetLeftScale()==7)) 
  or (tc2 and tc2:IsSetCard(0x997) and (tc2:GetLeftScale()==1 or tc2:GetLeftScale()==7))
end