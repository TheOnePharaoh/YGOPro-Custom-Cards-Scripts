--Forbidden Beast Inun
function c512000082.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000379,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c512000082.srcon)
	e1:SetTarget(c512000082.srtg)
	e1:SetOperation(c512000082.srop)
	c:RegisterEffect(e1)
end
function c512000082.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c512000082.fmfilter(c)
	return c:IsFaceup() and c:IsCode(511000380)
end
function c512000082.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c512000082.fmfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c512000082.filter(c)
	return c:IsCode(511000380) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY) 
		and (Duel.IsExistingMatchingCard(c512000082.fmfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or c:IsLocation(LOCATION_DECK))
end
function c512000082.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c512000082.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
