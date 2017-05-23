--DAL - Viris
function c99970960.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Damage
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970960,0))
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCondition(c99970960.damcon)
  e1:SetTarget(c99970960.damtg)
  e1:SetOperation(c99970960.damop)
  c:RegisterEffect(e1)
  --Immun Trap Card
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_IMMUNE_EFFECT)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x997))
  e2:SetValue(c99970960.efilter)
  c:RegisterEffect(e2)
  --ATK Down
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99970960,1))
  e3:SetCategory(CATEGORY_ATKCHANGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
  e3:SetCondition(c99970960.atkcon)
  e3:SetTarget(c99970960.atktg)
  e3:SetOperation(c99970960.atkop)
  c:RegisterEffect(e3)
  --Immune Trap Card
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_IMMUNE_EFFECT)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(c99970960.efilter)
  c:RegisterEffect(e4)
end
function c99970960.damcon(e,tp,eg,ep,ev,re,r,rp)
  return tp~=Duel.GetTurnPlayer()
end
function c99970960.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
  Duel.SetTargetPlayer(1-tp)
  local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
  Duel.SetTargetParam(dam)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99970960.damop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
  Duel.Damage(p,dam,REASON_EFFECT)
end
function c99970960.efilter(e,te)
  return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end
function c99970960.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler():IsSetCard(0x997) and not (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c99970960.atkfilter(c)
  return c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970960.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99970960.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler() 
  local tc=Duel.GetFirstTarget()
  Duel.ConfirmDecktop(tp,5)
  local g=Duel.GetDecktopGroup(tp,5)
  local ct=g:FilterCount(c99970960.atkfilter,nil)
  Duel.ShuffleDeck(tp)
  if ct>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(-ct*500)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  end
end