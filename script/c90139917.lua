--Vocaloid Kid Kasane Teto
function c90139917.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c90139917.splimit)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90139917,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c90139917.lvtg)
	e3:SetOperation(c90139917.lvop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(90139917,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c90139917.cost)
	e4:SetTarget(c90139917.tg)
	e4:SetOperation(c90139917.op)
	c:RegisterEffect(e4)
end
function c90139917.splimit(e,c)
	return c:IsSetCard(0xffffff-0x0dac405)
end
function c90139917.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405)
end
function c90139917.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90139917.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90139917,1))
	local lv=Duel.AnnounceNumber(tp,1,2,3)
	e:SetLabel(lv)
end
function c90139917.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c90139917.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c90139917.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90139917.filter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c90139917.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90139917.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function c90139917.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90139917.filter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
