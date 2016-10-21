--NGNL - Imanity Throne
function c99940080.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCondition(c99940080.condition)
  e1:SetOperation(c99940080.activate)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940080,0))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(c99940080.retcon)
  e2:SetTarget(c99940080.rettg)
  e2:SetOperation(c99940080.retop)
  c:RegisterEffect(e2)
end
function c99940080.condition(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local d1=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_DECK,0)
  local d2=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_DECK)
  return (d1-d2)>0 or (d2-d1)>0
end
function c99940080.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local d1=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_DECK,0)
  local d2=Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_DECK)
  if d1>d2 then
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,d1-d2)
  Duel.DiscardDeck(tp,d1-d2,REASON_EFFECT)
  elseif d2>d1 then
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,d2-d1)
  Duel.DiscardDeck(1-tp,d2-d1,REASON_EFFECT)
  end
end
function c99940080.retcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsPreviousLocation(LOCATION_HAND) and e:GetHandler():IsReason(REASON_EFFECT)) 
	or (e:GetHandler():GetPreviousLocation()==LOCATION_DECK and e:GetHandler():IsReason(REASON_EFFECT))
end
function c99940080.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99940080.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end