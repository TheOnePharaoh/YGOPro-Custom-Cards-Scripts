--SAO - Limitless Combat
function c99990560.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990560+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990560.target)
  e1:SetOperation(c99990560.activate)
  c:RegisterEffect(e1)
end
function c99990560.filter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990560.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99990560.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99990560.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c99990560.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990560.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_ATTACK_ALL)
  e1:SetValue(1)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e1)
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ATTACK_COST)
  e2:SetOperation(c99990560.atop)
  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  tc:RegisterEffect(e2)
  local e3=Effect.CreateEffect(e:GetHandler())
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e3:SetValue(500)
  tc:RegisterEffect(e3)
  end
end
function c99990560.atop(e,tp,eg,ep,ev,re,r,rp)  
  Duel.Damage(tp,500,REASON_COST)
end