--SAO - Leafa - ALO
function c99990220.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x999))
  c:EnableReviveLimit()
  --LP Gain
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990220.reccon)
  e1:SetTarget(c99990220.rectg)
  e1:SetOperation(c99990220.recop)
  c:RegisterEffect(e1)
  --Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetHintTiming(TIMING_DAMAGE_STEP)
  e2:SetCountLimit(1,99990220)
  e2:SetCondition(c99990220.spcon)
  e2:SetTarget(c99990220.sptg)
  e2:SetOperation(c99990220.spop)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990220.atkcon)
  e3:SetOperation(c99990220.atkop)
  c:RegisterEffect(e3)
end
function c99990220.reccon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c99990220.recfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990220.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99990220.recfilter,tp,LOCATION_GRAVE,0,nil)	
  if chk==0 then return ct > 0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function c99990220.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c99990220.recfilter,p,LOCATION_GRAVE,0,nil)
  if ct>0 then
  Duel.Recover(p,ct*300,REASON_EFFECT)
  end
end
function c99990220.spfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999)
end
function c99990220.spcon(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsExistingMatchingCard(c99990220.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99990220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99990220.thfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99990220.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.IsExistingMatchingCard(c99990220.spfilter,tp,LOCATION_MZONE,0,1,nil) then return end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(99990220,1)) 
  and Duel.IsExistingTarget(c99990220.thfilter,tp,LOCATION_GRAVE,0,1,nil) then 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99990220.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99990220.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990220.atkop(e,tp,eg,ep,ev,re,r,rp)
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