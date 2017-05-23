--DAL - Spirit Comrade
function c99970480.initial_effect(c)
  c:SetUniqueOnField(1,0,99970480)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --ATK Increase
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_SZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(c99970480.atktg)
  e2:SetValue(c99970480.atkval)
  c:RegisterEffect(e2)
  --Battle Indes
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
  e3:SetRange(LOCATION_SZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetCondition(c99970480.indcon)
  e3:SetTarget(c99970480.indtarget)
  e3:SetValue(c99970480.indct)
  c:RegisterEffect(e3)
  --Set Trap Card
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99970480,0))
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetTarget(c99970480.settg)
  e4:SetOperation(c99970480.setop)
  c:RegisterEffect(e4)
end
function c99970480.atktg(e,c)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) 
end
function c99970480.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970480.atkval(e,c)
  return Duel.GetMatchingGroupCount(c99970480.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c99970480.indfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970480.indcon(e)
  return Duel.IsExistingMatchingCard(c99970480.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c99970480.indtarget(e,c)
  return c:IsSetCard(0x997) and c:IsLevelAbove(5) 
end
function c99970480.indct(e,re,r,rp)
  if bit.band(r,REASON_BATTLE)~=0 then
    return 1
  else return 0 end
end
function c99970480.setfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(99970480)
end
function c99970480.settg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970480.setfilter,tp,LOCATION_DECK,0,1,nil,false) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970480.setop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
  local g=Duel.SelectMatchingCard(tp,c99970480.setfilter,tp,LOCATION_DECK,0,1,1,nil,false)
  local tc=g:GetFirst()
  if tc then
    Duel.SSet(tp,tc)
    Duel.ConfirmCards(1-tp,tc)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
end