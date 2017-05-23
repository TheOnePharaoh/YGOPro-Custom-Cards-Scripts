--DAL - Camael
function c99970420.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99970420,0))
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970420+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970420.damtg)
  e1:SetOperation(c99970420.damop)
  c:RegisterEffect(e1)
end
function c99970420.damfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsLevelAbove(5)
end
function c99970420.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970420.damfilter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99970420.damfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c99970420.damfilter,tp,LOCATION_MZONE,0,1,1,nil)
  local tc=g:GetFirst()
  local atk=tc:GetAttack()/2
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,atk)
end
function c99970420.damop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
  local atk=tc:GetAttack()/2
  Duel.Damage(1-tp,atk,REASON_EFFECT)
  end
  Duel.BreakEffect()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(99970420,1))
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_BATTLE_DESTROYING)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e1:SetCondition(aux.bdcon)
  e1:SetTarget(c99970420.damtg2)
  e1:SetOperation(c99970420.damop2)
  tc:RegisterEffect(e1)
  end
end
function c99970420.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local dam=e:GetHandler():GetBattleTarget():GetBaseAttack()
  if dam<0 then dam=0 end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(dam/2)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam/2)
end
function c99970420.damop2(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Damage(p,d,REASON_EFFECT)
end