--MSMM - Akuma Homura
function c99950360.initial_effect(c)
  c:EnableReviveLimit()
  c:SetUniqueOnField(1,0,99950360)
  --Cannot Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c99950360.splimit)
  c:RegisterEffect(e1)
  --Ritual Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99950360,0))
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99950360.ritcon)
  e2:SetOperation(c99950360.ritop)
  e2:SetValue(SUMMON_TYPE_RITUAL)
  c:RegisterEffect(e2)
  --Cannot Negate Summon
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  c:RegisterEffect(e3)
  --Banish
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_REMOVE)
  e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetTarget(c99950360.bantg)
  e4:SetOperation(c99950360.banop)
  c:RegisterEffect(e4)
  --Battle Indestructable
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e5:SetValue(1)
  c:RegisterEffect(e5)
  --Indes Effect
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e6:SetValue(1)
  c:RegisterEffect(e6)
  --Only one
  local e7=Effect.CreateEffect(c)
  e7:SetType(EFFECT_TYPE_SINGLE)
  e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
  e7:SetCondition(c99950360.excon)
  c:RegisterEffect(e7)
  local e8=e7:Clone()
  e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  c:RegisterEffect(e8)
  local e9=Effect.CreateEffect(c)
  e9:SetType(EFFECT_TYPE_FIELD)
  e9:SetRange(LOCATION_ONFIELD)
  e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e9:SetTargetRange(1,0)
  e9:SetCode(EFFECT_CANNOT_SUMMON)
  e9:SetTarget(c99950360.sumlimit)
  c:RegisterEffect(e9)
  local e10=e9:Clone()
  e10:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
  c:RegisterEffect(e10)
  local e11=e9:Clone()
  e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  c:RegisterEffect(e11)
  --Damage
  local e12=Effect.CreateEffect(c)
  e12:SetCategory(CATEGORY_DAMAGE)
  e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e12:SetCode(EVENT_SPSUMMON_SUCCESS)
  e12:SetRange(LOCATION_MZONE)
  e12:SetTarget(c99950360.dmgtg)
  e12:SetOperation(c99950360.dmgop)
  c:RegisterEffect(e12)
  --Negate
  local e13=Effect.CreateEffect(c)
  e13:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e13:SetType(EFFECT_TYPE_QUICK_O)
  e13:SetCode(EVENT_CHAINING)
  e13:SetCountLimit(1)
  e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e13:SetRange(LOCATION_MZONE)
  e13:SetCondition(c99950360.negcon)
  e13:SetTarget(c99950360.negtg)
  e13:SetOperation(c99950360.negop)
  c:RegisterEffect(e13)
  --Spell Zone
  local e14=Effect.CreateEffect(c)
  e14:SetCode(EFFECT_SEND_REPLACE)
  e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
  e14:SetRange(LOCATION_MZONE)
  e14:SetTarget(c99950360.sztg)
  e14:SetOperation(c99950360.szop)
  c:RegisterEffect(e14)
end
function c99950360.splimit(e,se,sp,st)
  return se:GetHandler():IsSetCard(9995)
end
function c99950360.filter1(c)
  return c:IsCode(99950000) and c:IsDiscardable()
end
function c99950360.filter2(c)
  return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(9995) and c:IsType(TYPE_RITUAL+TYPE_SPELL) and c:GetLevel()==5
end
function c99950360.ritcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99950360.filter2,tp,LOCATION_SZONE+LOCATION_GRAVE,0,5,nil)
  and Duel.IsExistingMatchingCard(c99950360.filter1,tp,LOCATION_HAND,0,1,nil)
end
function c99950360.ritop(e,tp,eg,ep,ev,re,r,rp,c)
  local c=e:GetHandler()
  Duel.DiscardHand(tp,c99950360.filter1,1,1,REASON_COST+REASON_DISCARD,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99950360.filter2,tp,LOCATION_SZONE+LOCATION_GRAVE,0,5,99,nil)
  local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  if ct>0 then
  Duel.Damage(1-tp,ct*500,REASON_EFFECT)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(ct*500)
  e1:SetReset(RESET_EVENT+0xff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
  end
end 
function c99950360.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c99950360.banop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c99950360.filter3(c)
  return c:IsFaceup() and (c:IsCode(99950120) or c:IsCode(99950360))
end
function c99950360.excon(e)
  return Duel.IsExistingMatchingCard(c99950360.filter3,0,LOCATION_ONFIELD,0,1,nil)
end
function c99950360.sumlimit(e,c)
  return c:IsCode(99950120) or c:IsCode(99950360)
end
function c99950360.dmgfilter(c,tp)
	return c:IsSetCard(9995) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c99950360.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=eg:Filter(c99950360.dmgfilter,e:GetHandler(),tp)
  local ct=g:GetCount()
  if chk==0 then return ct>0 end
  Duel.SetTargetCard(eg)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,ct,0,0)
end
function c99950360.dmgop(e,tp,eg,ep,ev,re,r,rp)
  local g=eg:Filter(c99950360.dmgfilter,e:GetHandler(),tp):Filter(Card.IsRelateToEffect,nil,e)
  if g:GetCount()>0 then
  local dmg=0
  local tc=g:GetFirst()
  while tc do
  dmg=dmg+tc:GetBaseAttack()
  tc=g:GetNext()
  end
  if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
  Duel.Damage(1-tp,dmg,REASON_EFFECT)
  end
  end
end
function c99950360.negcon(e,tp,eg,ep,ev,re,r,rp)
  return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c99950360.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c99950360.negop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
  if re:GetHandler():IsRelateToEffect(re) then
  Duel.Destroy(eg,REASON_EFFECT)
  end
end
function c99950360.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_HAND
  or c:GetDestination()==LOCATION_DECK or c:GetDestination()==LOCATION_REMOVED)  end
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
  return Duel.SelectYesNo(tp,aux.Stringid(99950360,1))
end
function c99950360.szop(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  --Spell
  local e1=Effect.CreateEffect(c)
  e1:SetCode(EFFECT_CHANGE_TYPE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetReset(RESET_EVENT+0x1fc0000)
  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
  c:RegisterEffect(e1)
  --To Hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99950360.thbcon)
  e2:SetTarget(c99950360.thbtg)
  e2:SetOperation(c99950360.thbop)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  Duel.RaiseEvent(c,99950280,e,0,tp,0,0)
end
function c99950360.filter4(c)
  return c:IsSetCard(9995) and bit.band(c:GetType(),0x81)==0x81 and c:GetLevel()==5 and c:IsAbleToHand()
end
function c99950360.thbcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c99950360.filter4,tp,LOCATION_REMOVED,0,1,nil,e,tp)
end
function c99950360.thbtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c99950360.filter4(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99950360.filter4,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectTarget(tp,c99950360.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99950360.thbop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,tc)
  end
end