--SAO - Aincrad
function c99990040.initial_effect(c)
  c:EnableCounterPermit(0x9999)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Add Counter
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCondition(c99990040.ctcon)
  e3:SetOperation(c99990040.ctop)
  c:RegisterEffect(e3)
  --ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetRange(LOCATION_FZONE)
  e3:SetTargetRange(LOCATION_MZONE,0)
  e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e3:SetValue(c99990040.val)
  c:RegisterEffect(e3)
  --DEF
  local e4=e3:Clone()
  e4:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e4)
  --Token
  local e5=Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e5:SetCountLimit(1)
  e5:SetCondition(c99990040.spcon)
  e5:SetTarget(c99990040.sptg)
  e5:SetOperation(c99990040.spop)
  c:RegisterEffect(e5)  
  --Destroy replace
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_DESTROY_REPLACE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_FZONE)
  e6:SetTarget(c99990040.desreptg)
  c:RegisterEffect(e6)
  --Add counter
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e7:SetProperty(EFFECT_FLAG_DELAY)
  e7:SetRange(LOCATION_FZONE)
  e7:SetCode(EVENT_SUMMON_SUCCESS)
  e7:SetCondition(c99990040.ctcon2)
  e7:SetOperation(c99990040.ctop2)
  c:RegisterEffect(e7)
  local e8=e7:Clone()
  e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e8)
  local e9=e7:Clone()
  e9:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e9)
end
function c99990040.ctcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a,d=d,a end
  return a:IsControler(tp) and a:IsSetCard(0x999) and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99990040.ctop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  e:GetHandler():AddCounter(0x9999,1)
  if c:GetCounter(0x9999)>=100 then
  Duel.Win(tp,0x50)
  end
end
function c99990040.val(e,c)
  return e:GetHandler():GetCounter(0x9999)*100
end
function c99990040.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99990040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990640,0,0x4011,500,500,2,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) end
  local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c99990040.spop(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
  if ft<=0 or not 
  Duel.IsPlayerCanSpecialSummonMonster(tp,99990640,0,0x4011,500,500,2,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then return end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  for i=1,ft do
  local token=Duel.CreateToken(tp,99990640)
  Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
  end
  Duel.SpecialSummonComplete()
end
function c99990040.desrepfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990040.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
  and Duel.IsExistingMatchingCard(c99990040.desrepfilter,tp,LOCATION_GRAVE,0,1,nil) end
  if Duel.SelectYesNo(tp,aux.Stringid(99990040,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990040.desrepfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  return true
  else return false end
end
function c99990040.ctfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c99990040.ctcon2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99990040.ctfilter,1,nil,tp)
end
function c99990040.ctop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  e:GetHandler():AddCounter(0x9999,1)
  if c:GetCounter(0x9999)>=100 then
  Duel.Win(tp,0x50)
  end
end