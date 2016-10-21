--NGNL - Game Start
function c99940120.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99940120.condition)
  e1:SetTarget(c99940120.target)
  e1:SetOperation(c99940120.activate)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940120.retcon)
  e2:SetTarget(c99940120.rettg)
  e2:SetOperation(c99940120.retop)
  c:RegisterEffect(e2)
end
function c99940120.condition(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c99940120.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function c99940120.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()     
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
  e1:SetCategory(CATEGORY_HANDES)
  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e1:SetCountLimit(1)
  e1:SetCondition(c99940120.discon)
  e1:SetTarget(c99940120.distg)
  e1:SetOperation(c99940120.disop)
  Duel.RegisterEffect(e1,tp)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
  e2:SetCategory(CATEGORY_HANDES)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetCountLimit(1)
  e2:SetCondition(c99940120.discon2)
  e2:SetTarget(c99940120.distg2)
  e2:SetOperation(c99940120.disop2)
  Duel.RegisterEffect(e2,tp)
end
function c99940120.discon(e,tp,eg,ep,ev,re,r,rp)
  return tp==Duel.GetTurnPlayer()
end
function c99940120.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c99940120.disop(e,tp,eg,ep,ev,re,r,rp)
  Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c99940120.discon2(e,tp,eg,ep,ev,re,r,rp)
  return tp~=Duel.GetTurnPlayer()
end
function c99940120.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99940120.disop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c99940120.retcon(e,tp,eg,ep,ev,re,r,rp)
  return (e:GetHandler():IsPreviousLocation(LOCATION_HAND) and e:GetHandler():IsReason(REASON_EFFECT)) 
  or (e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT))
end
function c99940120.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99940120.retop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  Duel.SendtoHand(c,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,c)
  Duel.Draw(1-tp,1,REASON_EFFECT)
  end
end