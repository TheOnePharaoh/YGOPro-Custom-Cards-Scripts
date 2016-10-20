--The Future Gear Destroyer
function c99199039.initial_effect(c)
	c:SetSPSummonOnce(99199039)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199039.splimit)
	e2:SetCondition(c99199039.splimcon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199039,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c99199039.thcon)
	e3:SetTarget(c99199039.thtg)
	e3:SetOperation(c99199039.thop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c99199039.atktg)
	e4:SetOperation(c99199039.atkop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,99199039)
	e5:SetCondition(c99199039.seccon)
	e5:SetTarget(c99199039.sectg)
	e5:SetOperation(c99199039.secop)
	c:RegisterEffect(e5)
end
function c99199039.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199039.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199039.cfilter(c,tp)
	return c:IsSetCard(0xff15) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199039.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99199039.cfilter,1,nil,tp)
end
function c99199039.thfilter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0xff15) and (lv==4 or lv==6) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99199039.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199039.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99199039.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99199039.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99199039.atkfilter(c)
	return c:IsSetCard(0xff15) and c:IsFaceup()
end
function c99199039.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199039.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c99199039.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99199039.atkfilter,tp,LOCATION_MZONE,0,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atkval=g:GetClassCount(Card.GetCode)*100
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atkval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c99199039.seccon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c99199039.secfilter(c)
	return c:IsSetCard(0xff15) and c:IsAbleToHand() and not c:IsCode(99199039)
end
function c99199039.sectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199039.secfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199039.secop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99199039.secfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
