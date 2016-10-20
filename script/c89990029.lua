--The Mystical Healing Tower
function c89990029.initial_effect(c)
	c:SetUniqueOnField(1,0,89990029)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetOperation(c89990029.recop)
	c:RegisterEffect(e2)
	--back to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(89990029,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(89990029)
	e3:SetCondition(c89990029.thcon)
	e3:SetTarget(c89990029.thtg)
	e3:SetOperation(c89990029.thop)
	c:RegisterEffect(e3)
end
function c89990029.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:GetControler()==tp
end
function c89990029.recop(e,tp,eg,ep,ev,re,r,rp)
	local ctv=eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
	local ct=eg:FilterCount(c89990029.filter,nil,tp)
	Duel.Recover(tp,ct*400,REASON_EFFECT)
	Duel.RaiseSingleEvent(e:GetHandler(),89990029,e,r,rp,ep,ctv)
end
function c89990029.rfilter(c)
	return c:IsFaceup() and c:IsCode(89990018)
end
function c89990029.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c89990029.rfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and e:GetHandler():IsLocation(LOCATION_SZONE) and ev>0
end
function c89990029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c89990029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ev,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
