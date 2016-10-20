--Ship Recyclement
function c22769934.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22769934.target)
	e1:SetOperation(c22769934.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769934,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22769934)
	e2:SetCondition(c22769934.immcon)
	e2:SetCost(c22769934.immcost)
	e2:SetOperation(c22769934.immop)
	c:RegisterEffect(e2)
end
function c22769934.tgfilter(c)
	return c:IsSetCard(0xaa12) and not c:IsCode(22769934) and c:IsAbleToGrave()
end
function c22769934.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769934.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22769934.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769934.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22769934.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22769934.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769934.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e1:SetValue(c22769934.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e1,tp)
end
function c22769934.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
