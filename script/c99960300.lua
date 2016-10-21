--BRS - The Tiny Bird The Colors
function c99960300.initial_effect(c)
  c:SetUniqueOnField(1,0,99960300)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_INDESTRUCTABLE)
  e2:SetRange(LOCATION_SZONE)
  e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
  e2:SetTarget(c99960300.infilter)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET) 
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCost(c99960300.cost)
  e3:SetTarget(c99960300.target)
  e3:SetOperation(c99960300.operation)
  c:RegisterEffect(e3)
end
function c99960300.infilter(e,c)
  return c:IsCode(99960280)
end
function c99960300.filter(c)
  return c:IsFaceup() and (c:IsCode(99960180) or c:IsCode(99960200) or c:IsCode(99960220) or c:IsCode(99960240) or c:IsCode(99960260))
end
function c99960300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function c99960300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c99960300.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c99960300.filter,tp,LOCATION_REMOVED,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99960300,0))
  local g=Duel.SelectTarget(tp,c99960300.filter,tp,LOCATION_REMOVED,0,1,5,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c99960300.operation(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
  if sg:GetCount()>0 then
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
  end
end