--SAO - Agil - SAO
function c99990720.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990720,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99990720.spcon1)
  e1:SetOperation(c99990720.spop1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990720,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1,99990720)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(c99990720.sptg2)
  e2:SetOperation(c99990720.spop2)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990720.atkcon)
  e3:SetOperation(c99990720.atkop)
  c:RegisterEffect(e3)
end
function c99990720.spfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and not c:IsCode(99990720)
end
function c99990720.spfilter2(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsAbleToGraveAsCost()
end
function c99990720.spcon1(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990720.spfilter1,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99990720.spfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c99990720.spop1(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990720.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990720.spfilter3(c,e,tp)
  return c:IsSetCard(0x999) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990720.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99990720.spfilter3(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99990720.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c99990720.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK)
  e1:SetValue(c:GetAttack()/2)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_SET_DEFENSE)
  e2:SetValue(c:GetDefense()/2)
  e2:SetReset(RESET_EVENT+0x1fe0000)
  c:RegisterEffect(e2)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990720.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
end
function c99990720.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a,d=d,a end
  if d:IsType(TYPE_XYZ) then
  e:SetLabel(d:GetRank()) 
  else
  e:SetLabel(d:GetLevel())
  end
  return a:IsControler(tp) and a:IsSetCard(0x999) and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99990720.atkop(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end