--SAO - Counteract
function c99990520.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99990520.condition)
  e1:SetTarget(c99990520.target)
  e1:SetOperation(c99990520.activate)
  c:RegisterEffect(e1)
  --Act In Hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetCondition(c99990520.handcon)
  c:RegisterEffect(e2)
end
function c99990520.filter1(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990520.condition(e,tp,eg,ep,ev,re,r,rp)
  return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c99990520.filter1,tp,LOCATION_MZONE,0,1,nil) 
end
function c99990520.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tg=Duel.GetAttacker()
  if chkc then return chkc==tg end
  if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
  Duel.SetTargetCard(tg)
end
function c99990520.thfilter(c)
  return c:IsSetCard(0x999)
end
function c99990520.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99990520.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end
function c99990520.handcon(e)
  return Duel.IsExistingMatchingCard(c99990520.filter1,tp,LOCATION_MZONE,0,2,nil) 
end