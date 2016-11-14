function c494476190.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Send topdeck
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(93892436,0))
  e1:SetCategory(CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLE_DAMAGE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
	e1:SetCondition(c494476190.ddcon)
	e1:SetTarget(c494476190.ddtg)
	e1:SetOperation(c494476190.ddop)
  c:RegisterEffect(e1)
  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c494476190.spcon)
	e2:SetOperation(c494476190.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27407330,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c494476190.rmcost)
	e3:SetTarget(c494476190.rmtg)
	e3:SetOperation(c494476190.rmop)
	c:RegisterEffect(e3)
end
function c494476190.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c494476190.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c494476190.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
function c494476190.spfilter(c)
	return c:GetLevel()>=5 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c494476190.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c494476190.spfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c494476190.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c494476190.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c494476190.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsDiscardable()
end
function c494476190.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c494476190.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c494476190.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c494476190.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c494476190.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c494476190.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c494476190.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c494476190.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
