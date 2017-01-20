--Village Within the Glade
function c77777886.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
  --recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777886,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_FLIP)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c77777886.damcon)
	e2:SetTarget(c77777886.damtg)
	e2:SetOperation(c77777886.damop)
	c:RegisterEffect(e2)
  --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40c))
	e3:SetValue(500)
	c:RegisterEffect(e3)
  --indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
  e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c77777886.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
  --to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_FZONE)
  e5:SetCountLimit(1,77777886)
	e5:SetTarget(c77777886.thtg)
	e5:SetOperation(c77777886.thop)
	c:RegisterEffect(e5)
  --atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x40c))
	e6:SetValue(500)
	c:RegisterEffect(e6)
end
function c77777886.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c77777886.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777886.cfilter,1,nil,tp)
end
function c77777886.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(eg:GetCount()*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,eg:GetCount()*300)
end
function c77777886.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function c77777886.target(e,c)
	return c:IsFacedown()
end


function c77777886.thfilter(c)
	return c:IsSetCard(0x40c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c77777886.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777886.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c77777886.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777886.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end