--SAO - Klein ALO
function c99990480.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x999))
  c:EnableReviveLimit()
  --Draw
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990480.drcon1)
  e1:SetTarget(c99990480.drtg1)
  e1:SetOperation(c99990480.drop1)
  c:RegisterEffect(e1)
  --ATK Up
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e2:SetValue(c99990480.val)
  c:RegisterEffect(e2)
  --ATK/DEF Gain
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLED)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990480.atkcon)
  e3:SetOperation(c99990480.atkop)
  c:RegisterEffect(e3)
end
function c99990480.drcon1(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c99990480.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990480.drop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()    
  local g=Duel.GetDecktopGroup(tp,1)
  local tc=g:GetFirst()
  Duel.Draw(tp,1,REASON_EFFECT)
  if tc then
  Duel.ConfirmCards(1-tp,tc)
  if tc:IsSetCard(0x999) and tc:IsType(TYPE_MONSTER) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99990480,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetValue(1)
  e1:SetCondition(c99990480.spcon)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99990480.drcon2)
  e2:SetTarget(c99990480.drtg2)
  e2:SetOperation(c99990480.drop2)
  tc:RegisterEffect(e2)
  end
  Duel.ShuffleHand(tp)
  end
end
function c99990480.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
end
function c99990480.drcon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99990480.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990480.drop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Draw(tp,1,REASON_EFFECT)
end
function c99990480.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990480.val(e,c)
  return Duel.GetMatchingGroupCount(c99990480.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*300
end
function c99990480.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990480.atkop(e,tp,eg,ep,ev,re,r,rp)
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