--Black Summoning Portal
function c77628951.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77628951.target)
	e1:SetOperation(c77628951.activate)
	c:RegisterEffect(e1)
	--restrict
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628951,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_STANDBY_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,77628951)
	e2:SetCondition(c77628951.negcon)
	e2:SetCost(c77628951.negcost)
	e2:SetOperation(c77628951.negop)
	c:RegisterEffect(e2)
end
function c77628951.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba003) and c:IsAbleToGrave()
end
function c77628951.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c77628951.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c77628951.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>1
			and Duel.IsExistingMatchingCard(c77628951.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77628951.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628951.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 and tg1:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c77628951.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetOperation(c77628951.desop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
		end
	end
end
function c77628951.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c77628951.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628951.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c77628951.grafilter,tp,LOCATION_GRAVE,0,4,nil)
end
function c77628951.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77628951.negop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(c77628951.efcon)
	e1:SetLabel(Duel.GetTurnCount())
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c77628951.efcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end