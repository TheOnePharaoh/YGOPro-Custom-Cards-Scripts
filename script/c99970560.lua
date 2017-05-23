--DAL - Gabriel
function c99970560.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99970560+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99970560.target)
  e1:SetOperation(c99970560.activate)
  c:RegisterEffect(e1)
end
function c99970560.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x997) and c:IsType(TYPE_MONSTER)
end
function c99970560.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingTarget(c99970560.atkfilter,tp,LOCATION_MZONE,0,1,nil) 
  local b2=Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil)
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
  op=Duel.SelectOption(tp,aux.Stringid(99970560,0),aux.Stringid(99970560,1))
  elseif b1 then
  op=Duel.SelectOption(tp,aux.Stringid(99970560,0))
  else
  op=Duel.SelectOption(tp,aux.Stringid(99970560,1))+1
  end
  e:SetLabel(op)
  if op==0 then
  e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  else
  e:SetCategory(CATEGORY_POSITION)
  local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
  end
end
function c99970560.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local op=e:GetLabel()
  if op==0 then
  local g1=Duel.GetMatchingGroup(c99970560.atkfilter,tp,LOCATION_MZONE,0,nil)
  if g1:GetCount()>0 then
  local atk=g1:GetCount()*200
  local sc1=g1:GetFirst()
  while sc1 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(atk)
  sc1:RegisterEffect(e1)
  sc1=g1:GetNext()
  end
  end
  Duel.BreakEffect()
  local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  if g2:GetCount()>0 then
  local sc2=g2:GetFirst()
  while sc2 do
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  e1:SetValue(-500)
  sc2:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  sc2:RegisterEffect(e2)
  sc2=g2:GetNext()
  end
  end
  else
  local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
  Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
  end
end