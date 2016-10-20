--ADE Sauronixx
function c70649932.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649932,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c70649932.thcon)
	e2:SetTarget(c70649932.thtg)
	e2:SetOperation(c70649932.thop)
	c:RegisterEffect(e2)
end
function c70649932.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c70649932.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c70649917.filter,1,nil)
end
function c70649932.filter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c70649932.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70649932.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70649932.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c70649932.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c70649932.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end