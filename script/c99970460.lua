--DAL - Licorice Assault
function c99970460.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99970460.cost)
  e1:SetTarget(c99970460.target)
  e1:SetOperation(c99970460.activate)
  c:RegisterEffect(e1)
end
function c99970460.filter1(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsType(TYPE_XYZ)
end
function c99970460.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970460.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingMatchingCard(c99970460.filter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
  local g=Duel.SelectTarget(tp,c99970460.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  Duel.Release(tc,REASON_COST)
end
function c99970460.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
  local v=0
  if Duel.GetMatchingGroupCount(c99970460.filter2,tp,LOCATION_MZONE,0,nil)==1 then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970460.activate(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) then 
  if v==1 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,3,e:GetHandler())
  if g:GetCount()>0 then
  Duel.Destroy(g,REASON_EFFECT)
  end
  else 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,2,e:GetHandler())
  if g:GetCount()>0 then
  Duel.Destroy(g,REASON_EFFECT)
  end
  end
  end
end