--DAL - Megiddo
function c99970440.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99970440.damcost)
  e1:SetTarget(c99970440.damtg)
  e1:SetOperation(c99970440.damop)
  c:RegisterEffect(e1)
end
function c99970440.filter1(c)
  return c:IsCode(99970420) and c:IsAbleToRemoveAsCost()
end
function c99970440.filter2(c)
  return c:IsFaceup() and c:IsSetCard(9997) and c:IsLevelAbove(5)
end
function c99970440.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99970440.filter1,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local rg=Duel.SelectMatchingCard(tp,c99970440.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c99970440.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  if Duel.GetMatchingGroupCount(c99970440.filter2,tp,LOCATION_MZONE,0,nil)==1 then v=1 e:SetLabel(v) 
  else v=0 e:SetLabel(v) end
end
function c99970440.damop(e,tp,eg,ep,ev,re,r,rp)
  local v=e:GetLabel()
  local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  if v==1 then 
  Duel.Damage(1-tp,1000+ct*600,REASON_EFFECT)
  else 
  Duel.Damage(1-tp,500+ct*300,REASON_EFFECT)
  end
end