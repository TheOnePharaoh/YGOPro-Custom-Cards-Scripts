--SAO - Silica ALO
function c99990460.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x999))
  c:EnableReviveLimit()
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990460.damcon)
  e1:SetTarget(c99990460.damtg)
  e1:SetOperation(c99990460.damop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990460,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99990460.sptg)
  e2:SetOperation(c99990460.spop)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990460.atkcon)
  e3:SetOperation(c99990460.atkop)
  c:RegisterEffect(e3)
end
function c99990460.damcon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c99990460.damfilter(c)
  return c:IsFacedown()
end
function c99990460.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99990460.damfilter,tp,0,LOCATION_SZONE,1,nil,e,tp) end
  local ct=Duel.GetMatchingGroupCount(c99990460.damfilter,tp,0,LOCATION_SZONE,nil)
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(ct*500)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c99990460.damop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetMatchingGroupCount(c99990460.damfilter,tp,0,LOCATION_SZONE,nil)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Damage(p,ct*500,REASON_EFFECT)
end
function c99990460.spfilter1(c,e,tp)
  return c:IsCode(99990200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99990460.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99990460.spfilter1(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingTarget(c99990460.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99990460.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99990460.spfilter2(c,e,tp)
   return c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990460.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
  and Duel.IsExistingMatchingCard(c99990460.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(99990460,1)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990460.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
  end
  end
end
function c99990460.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990460.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
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