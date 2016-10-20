--Hydrush Damsel
function c83070007.initial_effect(c)
	--shuffle and add 1 Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070007,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,83070007)
	e2:SetCost(c83070007.cost)
	e2:SetTarget(c83070007.tg)
	e2:SetOperation(c83070007.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c83070007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,83070007)==0 end
	Duel.RegisterFlagEffect(tp,83070007,RESET_PHASE+PHASE_END,0,1)
end
function c83070007.filter(c)
	return c:IsSetCard(0x837) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c83070007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83070007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c83070007.senfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c83070007.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c83070007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+8307 and Duel.IsExistingTarget(c83070007.senfilter,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(83070007,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c83070007.senfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
