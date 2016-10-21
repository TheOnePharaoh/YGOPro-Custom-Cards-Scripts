--NGNL - Sora
function c99940000.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Scale change
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940000,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetOperation(c99940000.scop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99940000.tdcon)
  e3:SetTarget(c99940000.tdtg)
  e3:SetOperation(c99940000.tdop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940000,1))
  e4:SetCategory(CATEGORY_TOHAND)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(c99940000.target)
  e4:SetOperation(c99940000.operation)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DELAY)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_DRAW)
  e5:SetCondition(c99940000.thcon)
  e5:SetTarget(c99940000.thtg)
  e5:SetOperation(c99940000.thop)
  c:RegisterEffect(e5)
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e6:SetProperty(EFFECT_FLAG_DELAY)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EVENT_DRAW)
  e6:SetOperation(c99940000.atkop)
  c:RegisterEffect(e6)
end
function c99940000.scop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CHANGE_LSCALE)
  e1:SetValue(2)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_CHANGE_RSCALE)
  c:RegisterEffect(e2)
  Duel.BreakEffect()
  Duel.Draw(tp,1,REASON_EFFECT)
  Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c99940000.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c99940000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c99940000.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c99940000.filter(c)
  return c:IsFaceup()
end
function c99940000.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c99940000.operation(e,tp,eg,ep,ev,re,r,rp)
  local res=Duel.TossCoin(tp,1)
  if res==1 then 
  local g=Duel.GetMatchingGroup(c99940000.filter,tp,0,LOCATION_MZONE,nil)
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  else  
  local g=Duel.GetMatchingGroup(c99940000.filter,tp,LOCATION_MZONE,0,nil)
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  end
end
function c99940000.thcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940000.thfilter(c)
  return c:IsSetCard(9994) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c99940000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99940000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99940000.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99940000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c99940000.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()   
 	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end