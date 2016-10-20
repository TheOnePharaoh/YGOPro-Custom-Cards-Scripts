--Vocaloid Kaito
function c58656934.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58656934,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c58656934.thtg)
	e2:SetOperation(c58656934.thop)
	c:RegisterEffect(e2)
end
function c58656934.filter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c58656934.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c58656934.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c58656934.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c58656934.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	end