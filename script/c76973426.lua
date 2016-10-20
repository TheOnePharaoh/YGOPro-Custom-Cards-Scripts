--Vocaloid Luka Megurine Mdl - 02
function c76973426.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76973426.spcon)
	c:RegisterEffect(e1)
	--control cannot switch
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c76973426.atkcon)
	e2:SetOperation(c76973426.atkop)
	c:RegisterEffect(e2)
end
function c76973426.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)
end
function c76973426.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c76973426.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c76973426.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c76973426.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76973426,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
