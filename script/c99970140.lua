--DAL - Sandalphon
function c99970140.initial_effect(c)
  --Increase ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970140,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970140+EFFECT_COUNT_CODE_OATH)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99970140.target)
  e1:SetOperation(c99970140.operation)
  c:RegisterEffect(e1)
end
function c99970140.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970140.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970140.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99970140.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970140.operation(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    end
  Duel.BreakEffect()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    --Second Attack
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetDescription(aux.Stringid(99970140,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(c99970140.atkcon)
    e2:SetTarget(c99970140.atktg)
    e2:SetOperation(c99970140.atkop)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    --Double Damage
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e3:SetCondition(c99970140.rdcon)
    e3:SetOperation(c99970140.rdop)
    tc:RegisterEffect(e3)
  end
end
function c99970140.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
  and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c99970140.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToBattle() end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99970140.atkop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EXTRA_ATTACK)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
  e:GetHandler():RegisterEffect(e1)
end
function c99970140.rdcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c99970140.rdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev*2)
end