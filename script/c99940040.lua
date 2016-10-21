--NGNL - Stephanie Dola
function c99940040.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Scale change
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99940040,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetOperation(c99940040.scop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_DRAW)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetRange(LOCATION_PZONE)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetCondition(c99940040.drcon)
  e3:SetTarget(c99940040.drtg)
  e3:SetOperation(c99940040.drop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99940040,1))
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_SPSUMMON_PROC)
  e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e4:SetRange(LOCATION_HAND)
  e4:SetCondition(c99940040.spcon)
  e4:SetValue(1)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_DELAY)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EVENT_DRAW)
  e5:SetCondition(c99940040.millcon)
  e5:SetTarget(c99940040.milltg)
  e5:SetOperation(c99940040.millop)
  c:RegisterEffect(e5)
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e6:SetProperty(EFFECT_FLAG_DELAY)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EVENT_DRAW)
  e6:SetOperation(c99940040.atkop)
  c:RegisterEffect(e6)
  local e7=Effect.CreateEffect(c)
  e7:SetCategory(CATEGORY_DESTROY)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e7:SetCode(EVENT_SPSUMMON_SUCCESS)
  e7:SetCondition(c99940040.drdiscon)
  e7:SetTarget(c99940040.drdistg)
  e7:SetOperation(c99940040.drdisop)
  c:RegisterEffect(e7)
end
function c99940040.scop(e,tp,eg,ep,ev,re,r,rp)
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
function c99940040.drfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER) and c:IsSetCard(9994)
end
function c99940040.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99940040.drfilter,1,nil,tp)
end
function c99940040.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99940040.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c99940040.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(9994)
end
function c99940040.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and	Duel.IsExistingMatchingCard(c99940040.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c99940040.millcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c99940040.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,2)
end
function c99940040.millop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end
function c99940040.atkop(e,tp,eg,ep,ev,re,r,rp)
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
function c99940040.drdiscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c99940040.drdistg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c99940040.drdisop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	if h2>0 then 
	Duel.ShuffleHand(1-tp)
	Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end