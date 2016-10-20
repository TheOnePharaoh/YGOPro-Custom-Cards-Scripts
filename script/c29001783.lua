--The Deep Sea
function c29001783.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29001783,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,29001783)
	e4:SetCondition(c29001783.condition)
	e4:SetTarget(c29001783.destg)
	e4:SetOperation(c29001783.desop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29001783,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCountLimit(1,29001783)
	e5:SetCondition(c29001783.condition)
	e5:SetTarget(c29001783.drtg)
	e5:SetOperation(c29001783.drop)
	c:RegisterEffect(e5)
	--salvage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29001783,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCountLimit(1,29001783)
	e6:SetCondition(c29001783.condition)
	e6:SetTarget(c29001783.thtg)
	e6:SetOperation(c29001783.thop)
	c:RegisterEffect(e6)
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(29001783,3))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetCountLimit(1,29001783)
	e7:SetCondition(c29001783.condition)
	e7:SetTarget(c29001783.damtg)
	e7:SetOperation(c29001783.damop)
	c:RegisterEffect(e7)
	--convert
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e8:SetCode(EFFECT_CHANGE_RACE)
	e8:SetValue(RACE_FISH)
	c:RegisterEffect(e8)
end
function c29001783.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x10a7)
end
function c29001783.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and eg:IsExists(c29001783.cfilter,1,nil)
end
function c29001783.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29001783.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c29001783.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29001783.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c29001783.thfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x10a7) and c:IsAbleToHand()
end
function c29001783.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29001783.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c29001783.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29001783.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29001783.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c29001783.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
