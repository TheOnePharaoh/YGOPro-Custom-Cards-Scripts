--Bacteria of the Arch Beetle
function c78330026.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330026,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c78330026.thcon)
	e2:SetTarget(c78330026.thtg)
	e2:SetOperation(c78330026.thop)
	c:RegisterEffect(e2)
	--draw and banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78330026,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c78330026.drcon)
	e3:SetTarget(c78330026.drtg)
	e3:SetOperation(c78330026.drop)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78330026,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCost(c78330026.thcost)
	e4:SetTarget(c78330026.thtg2)
	e4:SetOperation(c78330026.thop2)
	c:RegisterEffect(e4)
end
function c78330026.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c78330026.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xac9812) and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c78330026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78330026.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c78330026.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c78330026.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(78330026,3))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c78330026.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c78330026.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c78330026.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,Card.IsRace,p,LOCATION_HAND,0,1,1,nil,RACE_INSECT)
	local tg=g:GetFirst()
	if tg then
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

function c78330026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c78330026.scfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xac9812) and c:IsAbleToHand()
end
function c78330026.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c78330026.scfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78330026.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c78330026.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c78330026.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end