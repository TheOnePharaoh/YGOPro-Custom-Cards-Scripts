--SAO - Guns And Swords
function c99990540.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990540+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99990540.condition)
  e1:SetTarget(c99990540.target)
  e1:SetOperation(c99990540.activate)
  c:RegisterEffect(e1)
end
function c99990540.condition(e,tp,eg,ep,ev,re,r,rp)
  return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c99990540.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
end
function c99990540.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  or not Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK
  then return end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99990540,0))
  local g1=Duel.SelectMatchingCard(tp,c99990540.filter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g1)
  Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(99990540,0))
  local g2=Duel.SelectMatchingCard(1-tp,c99990540.filter,1-tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g2)
  local c1=g1:GetFirst()
  local c2=g2:GetFirst()
  if c2:IsAttackable() and not c2:IsImmuneToEffect(e) and not c1:IsImmuneToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e1:SetValue(Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*300)
  c1:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
  e2:SetValue(Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND)*300)
  c2:RegisterEffect(e2)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetDescription(aux.Stringid(99990540,0))
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetCondition(c99990540.damcon)
  e3:SetTarget(c99990540.damtg)
  e3:SetOperation(c99990540.damop)
  e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
  e3:SetLabelObject(c1)
  Duel.RegisterEffect(e3,tp)
  c1:RegisterFlagEffect(99990540,RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_DAMAGE,0,1)
  local e4=Effect.CreateEffect(e:GetHandler())
  e4:SetDescription(aux.Stringid(99990540,0))
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetCondition(c99990540.damcon2)
  e4:SetTarget(c99990540.damtg2)
  e4:SetOperation(c99990540.damop2)
  e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
  e4:SetLabelObject(c2)
  Duel.RegisterEffect(e4,tp)
  c2:RegisterFlagEffect(99990540,RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_DAMAGE,0,1)
  Duel.CalculateDamage(c1,c2)
  Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
  end
end
function c99990540.damcon(e,tp,eg,ep,ev,re,r,rp)
  local c1=e:GetLabelObject()
  return eg:IsContains(c1) and c1:GetFlagEffect(99990540)~=0 and c1:GetOwner()==tp
  and c1:IsLocation(LOCATION_GRAVE) and c1:IsReason(REASON_BATTLE)
end
function c99990540.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1000)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c99990540.damop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end
function c99990540.damcon2(e,tp,eg,ep,ev,re,r,rp)
  local c2=e:GetLabelObject()
  return eg:IsContains(c2) and c2:GetFlagEffect(99990540)~=0 and c2:GetOwner()==1-tp
  and c2:IsLocation(LOCATION_GRAVE) and c2:IsReason(REASON_BATTLE) 
end
function c99990540.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(1000)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c99990540.damop2(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end