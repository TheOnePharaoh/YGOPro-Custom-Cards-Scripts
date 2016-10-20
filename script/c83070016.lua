--Hydrush Condensation
function c83070016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(8307)
	e2:SetCondition(c83070016.ctcon)
	e2:SetOperation(c83070016.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83070016,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,83070016)
	e3:SetCost(c83070016.spcost)
	e3:SetTarget(c83070016.sptg)
	e3:SetOperation(c83070016.spop)
	c:RegisterEffect(e3)
end
function c83070016.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c83070016.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1837,1)
end
function c83070016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1837,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1837,3,REASON_COST)
end
function c83070016.filter(c)
	return c:IsSetCard(0x837) and c:IsAbleToHand()
end
function c83070016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83070016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c83070016.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c83070016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
