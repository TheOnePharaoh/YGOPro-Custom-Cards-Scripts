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
end
function c99990520.condition(e,tp,eg,ep,ev,re,r,rp)
  return tp~=Duel.GetTurnPlayer()
end
function c99990520.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9999) and c:IsType(TYPE_MONSTER)
end
function c99990520.filter2(c)
  return c:IsSetCard(9999) and c:IsType(TYPE_MONSTER)
end
function c99990520.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990520.filter1,tp,LOCATION_MZONE,0,1,nil) end
  if Duel.IsExistingTarget(c99990520.filter1,tp,LOCATION_MZONE,0,2,nil) then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99990520.activate(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  Duel.NegateAttack()
  if v==1 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99990520.filter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
  end
end