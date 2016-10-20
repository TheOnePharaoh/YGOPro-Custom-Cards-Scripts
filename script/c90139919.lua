--TenGaku - Song of Tainted Intent and Betrayal
function c90139919.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90139919+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c90139919.cost)
	e1:SetOperation(c90139919.operation)
	c:RegisterEffect(e1)
	--salvate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90139919,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,90139919+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c90139919.thcost)
	e2:SetTarget(c90139919.thtg)
	e2:SetOperation(c90139919.thop)
	c:RegisterEffect(e2)
end
function c90139919.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c90139919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90139919.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c90139919.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c90139919.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c90139919.sucop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c90139919.cedop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e2)
	Duel.RegisterEffect(e2,tp)
end

function c90139919.sucfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c90139919.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c90139919.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c90139919.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c90139919.chainlm)
	end
end
function c90139919.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90139919.thfilter(c)
	return c:IsSetCard(0x0dac406) and c:IsAbleToHand()
end
function c90139919.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90139919.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c90139919.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90139919.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
