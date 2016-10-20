--Vocaloid Ignition
function c83733456.initial_effect(c)
	c:SetUniqueOnField(1,0,83733456)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83733456,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(2)
	e2:SetOperation(c83733456.drop)
	c:RegisterEffect(e2)
end
function c83733456.filter(c,sp)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:GetSummonPlayer()==sp
end
function c83733456.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c83733456.filter,1,nil,1-tp) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
