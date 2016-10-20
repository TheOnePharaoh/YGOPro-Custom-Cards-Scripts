--Vocaloid Kasane Teto
function c52414158.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c52414158.efilter)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52414158,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c52414158.tg)
	e3:SetOperation(c52414158.op)
	c:RegisterEffect(e3)
end
function c52414158.efilter(e,c)
	return c:IsType(TYPE_TUNER)
end
function c52414158.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52414158.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52414158.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52414158.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c52414158.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
