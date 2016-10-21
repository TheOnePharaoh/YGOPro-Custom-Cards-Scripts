--NGNL - Shiro
function c99940020.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Scale change
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940020,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetOperation(c99940020.scop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c99940020.tgcon)
  e3:SetTarget(c99940020.tgtg)
  e3:SetOperation(c99940020.tgop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99940020.thcon)
  e4:SetTarget(c99940020.thtg)
  e4:SetOperation(c99940020.thop)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DELAY)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_DRAW)
  e5:SetCondition(c99940020.thcon2)
  e5:SetTarget(c99940020.thtg2)
  e5:SetOperation(c99940020.thop2)
  c:RegisterEffect(e5)
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e6:SetProperty(EFFECT_FLAG_DELAY)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EVENT_DRAW)
  e6:SetOperation(c99940020.atkop)
  c:RegisterEffect(e6)
end
function c99940020.scop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CHANGE_LSCALE)
  e1:SetValue(4)
  e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_CHANGE_RSCALE)
  c:RegisterEffect(e2)
  Duel.BreakEffect()
  Duel.Draw(tp,1,REASON_EFFECT)
  Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c99940020.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99940020.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function c99940020.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and 	g2:GetCount()>0 then
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
end
function c99940020.thfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c99940020.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99940020.thfilter,1,nil,tp)
end
function c99940020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c99940020.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function c99940020.thcon2(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940020.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c99940020.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	local rs=g:RandomSelect(1-tp,1)
	local card=rs:GetFirst()
	if card==nil then return end
	Duel.SendtoHand(card,tp,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
function c99940020.atkop(e,tp,eg,ep,ev,re,r,rp)
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