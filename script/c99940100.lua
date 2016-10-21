--NGNL - Kingdom Of Elkia
function c99940100.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)  
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Draw
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99940100.drcon)
  e2:SetOperation(c99940100.drop)
  c:RegisterEffect(e2)
  --Indestrct
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCondition(c99940100.indcon)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  --Dice
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetCountLimit(1)
  e4:SetRange(LOCATION_FZONE)
  e4:SetTarget(c99940100.target)
  e4:SetOperation(c99940100.operation)
  c:RegisterEffect(e4)
end
function c99940100.drfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(9994) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c99940100.drcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99940100.drfilter,1,nil,tp)
end
function c99940100.drop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Draw(tp,1,REASON_EFFECT)
  Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c99940100.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c99940100.filter(c)
  return c:IsAbleToHand()
end
function c99940100.filter2(c)
  return c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99940100.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c99940100.operation(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local dice=Duel.TossDice(tp,1)
  if dice==1 then
  Duel.Draw(tp,1,REASON_EFFECT)
  Duel.Draw(1-tp,1,REASON_EFFECT)
  elseif dice==2 then
  if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
  local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 and  g2:GetCount()>0 then
  g1:Merge(g2)
  Duel.SendtoGrave(g1,REASON_EFFECT)
  end
  elseif Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 then
  Duel.SendtoGrave(g1,REASON_EFFECT)
  end
  elseif not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
  local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_DECK,0,1,1,nil)
  if g2:GetCount()>0 then
  Duel.SendtoGrave(g2,REASON_EFFECT)
  end
  else return true end
  elseif dice==3 then
  if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
  local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
  local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
  g1:Merge(g2)
  Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
  elseif Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and not Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
  local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
  Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
  elseif not Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
  local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
  Duel.SendtoGrave(g2,REASON_DISCARD+REASON_EFFECT)
  else return true end
  elseif dice==4 then
  if Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_ONFIELD,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99940100.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g1:GetCount()>0 and  g2:GetCount()>0 then
  g1:Merge(g2)
  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  end
  elseif Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_ONFIELD,0,1,nil) and not Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_ONFIELD,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99940100.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
  if g1:GetCount()>0 then
  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  end
  elseif not Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_ONFIELD,1,nil) then
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g2:GetCount()>0 then
  Duel.SendtoHand(g2,nil,REASON_EFFECT)
  end
  else return true end
  elseif dice==5 then
  if Duel.IsExistingTarget(c99940100.filter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c99940100.filter2,tp,0,LOCATION_GRAVE,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g1=Duel.SelectTarget(tp,c99940100.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter2,tp,0,LOCATION_GRAVE,1,1,nil)
  if g1:GetCount()>0 and  g2:GetCount()>0 then
  g1:Merge(g2)
  Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
  end
  elseif Duel.IsExistingTarget(c99940100.filter2,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingTarget(c99940100.filter2,tp,0,LOCATION_GRAVE,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g1=Duel.SelectTarget(tp,c99940100.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
  if g1:GetCount()>0 then
  Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
  end
  elseif not Duel.IsExistingTarget(c99940100.filter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c99940100.filter2,tp,0,LOCATION_GRAVE,1,nil) then
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter2,tp,0,LOCATION_GRAVE,1,1,nil)
  if g2:GetCount()>0 then
  Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
  end
  else return true end
  else
  if Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99940100.filter,tp,LOCATION_DECK,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter,tp,0,LOCATION_DECK,1,1,nil)
  if g1:GetCount()>0 and  g2:GetCount()>0 then
  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g1)
  Duel.SendtoHand(g2,nil,REASON_EFFECT)
  Duel.ConfirmCards(tp,g2)
  end
  elseif Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99940100.filter,tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 then
  Duel.SendtoHand(g1,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g1)
  end
  elseif not Duel.IsExistingTarget(c99940100.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c99940100.filter,tp,0,LOCATION_DECK,1,nil) then
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(1-tp,c99940100.filter,tp,0,LOCATION_DECK,1,1,nil)
  if g2:GetCount()>0 then
  Duel.SendtoHand(g2,nil,REASON_EFFECT)
  Duel.ConfirmCards(tp,g2)
  end
  else return true end
  end
end