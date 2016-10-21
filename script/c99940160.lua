--NGNL - The Lucky Draw
function c99940160.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99940160.condition)
  e1:SetTarget(c99940160.target)
  e1:SetOperation(c99940160.activate)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940160.retcon)
  e2:SetTarget(c99940160.rettg)
  e2:SetOperation(c99940160.retop)
  c:RegisterEffect(e2)
end
function c99940160.filter(c)
  return c:IsSetCard(9994)
end

function c99940160.condition(e,tp,eg,ep,ev,re,r,rp)
  local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
  local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
  return (tc1 and c99940160.filter(tc1)) or (tc2 and c99940160.filter(tc2))
end
function c99940160.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99940160.activate(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 then
  local tc=Duel.GetOperatedGroup():GetFirst()
  Duel.ConfirmCards(1-tp,tc)
  Duel.ShuffleHand(tp)
  Duel.BreakEffect()
  if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(9994) then
  local res=Duel.TossCoin(tp,1)
  if res==1 then
  if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
  Duel.BreakEffect()
  Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
  end
  else 
  if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
  Duel.BreakEffect()
  Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
  end
  end
  end
  end
end
function c99940160.retcon(e,tp,eg,ep,ev,re,r,rp)
  return (e:GetHandler():IsPreviousLocation(LOCATION_HAND) and e:GetHandler():IsReason(REASON_EFFECT)) 
  or (e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT))
end
function c99940160.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99940160.retop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.SendtoHand(c,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,c)
  Duel.Draw(1-tp,1,REASON_EFFECT)
  end
end