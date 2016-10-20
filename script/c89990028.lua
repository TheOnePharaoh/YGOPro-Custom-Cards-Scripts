--mystical fountain
function c89990028.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c89990028.cost)
	e1:SetTarget(c89990028.target)
	e1:SetOperation(c89990028.operation)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c89990028.atktg)
	e2:SetCountLimit(1)
	e2:SetValue(c89990028.valcon)
	c:RegisterEffect(e2)
	--power summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c89990028.drcost)
	e3:SetTarget(c89990028.drtg)
	e3:SetOperation(c89990028.drop)
	c:RegisterEffect(e3)
end
function c89990028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c89990028.filter(c)
	return c:GetCode()==89990018 and c:IsAbleToHand()
end
function c89990028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c89990028.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c89990028.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c89990028.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c89990028.atktg(e,c)
	return c:IsSetCard(0x22b)
end
function c89990028.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c89990028.cfilter(c)
	return c:IsFaceup() and c:IsCode(89990017) and c:IsAbleToGraveAsCost()
end
function c89990028.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c89990028.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c89990028.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c89990028.spfilter(c,e,tp)
	return c:IsCode(89990032) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c89990028.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c89990028.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c89990028.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c89990028.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
