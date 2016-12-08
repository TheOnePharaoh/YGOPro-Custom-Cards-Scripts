--SAO - Guns And Swords
function c99990540.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_BATTLE_START)
  e1:SetCountLimit(1,99990540+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99990540.condition)
  e1:SetTarget(c99990540.target)
  e1:SetOperation(c99990540.activate)
  c:RegisterEffect(e1)
end
function c99990540.filter1(c)
  return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x999)
end
function c99990540.filter2(c,tp)
  return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99990540.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==tp
  and Duel.IsExistingMatchingCard(c99990540.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99990540.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
end
function c99990540.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  or not Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK)
  then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g1=Duel.SelectMatchingCard(tp,c99990540.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g1)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g2=Duel.SelectMatchingCard(1-tp,c99990540.filter2,1-tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g2)
  local c1=g1:GetFirst()
  local c2=g2:GetFirst()
  if c2:IsAttackable() and not c2:IsImmuneToEffect(e) and not c1:IsImmuneToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_DAMAGE_STEP_END)
  e1:SetTarget(c99990540.damtg)
  e1:SetOperation(c99990540.damop)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  e1:SetLabelObject(c2)
  Duel.RegisterEffect(e1,tp)
  c2:RegisterFlagEffect(99990540,RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_DAMAGE,0,1)
  Duel.CalculateDamage(c1,c2)
  Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
  end
end
function c99990540.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c2=e:GetLabelObject()
  local bc=c2:GetBattleTarget()
  if chk==0 then return Duel.GetAttackTarget()~=nil
  and bc:IsRelateToBattle() and bc:IsLocation(LOCATION_ONFIELD) end
end
function c99990540.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99990540.damop(e,tp,eg,ep,ev,re,r,rp)
  local c2=e:GetLabelObject()
  local bc=c2:GetBattleTarget()
  if bc:IsRelateToBattle() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990540.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
  and Duel.SelectYesNo(tp,aux.Stringid(99990540,0)) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990540.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetOperation(c99990540.desop)
  e1:SetReset(RESET_EVENT+0x1fe0000)
  e1:SetCountLimit(1)
  g:GetFirst():RegisterEffect(e1,true)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_BP_TWICE)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetTargetRange(1,0)
  e3:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
  Duel.RegisterEffect(e3,tp)
  end
  end
end
function c99990540.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end