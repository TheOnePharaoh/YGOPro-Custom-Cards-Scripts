--DAL - AI
function c99970920.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Recovar
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970920,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCondition(c99970920.reccon)
  e1:SetTarget(c99970920.rectg)
  e1:SetOperation(c99970920.recop)
  c:RegisterEffect(e1)
  --Immun Spell Card
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x997))
  e2:SetValue(c99970920.efilter)
  c:RegisterEffect(e2)
  --ATK Up
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970920,1))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(c99970920.atkcon)
  e3:SetTarget(c99970920.atktg)
  e3:SetOperation(c99970920.atkop)
  c:RegisterEffect(e3)
  --Immune Spell Card
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99970920.efilter)
  c:RegisterEffect(e4)
end
function c99970920.reccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99970920.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
  Duel.SetTargetPlayer(tp)
  local rec=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*300
  Duel.SetTargetParam(rec)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c99970920.recop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local rec=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*300
  Duel.Recover(p,rec,REASON_EFFECT)
end
function c99970920.efilter(e,te)
  return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c99970920.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970920.atkfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x997)
end
function c99970920.atkfilter2(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970920.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970920.atkfilter1(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970920.atkfilter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99970920.atkfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970920.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local tc=Duel.GetFirstTarget()
  Duel.ConfirmDecktop(tp,5)
  local g=Duel.GetDecktopGroup(tp,5)
  local ct=g:FilterCount(c99970920.atkfilter2,nil)
  Duel.ShuffleDeck(tp)
  if ct>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(ct*500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end