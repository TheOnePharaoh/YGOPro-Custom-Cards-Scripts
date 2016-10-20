--A Melody From the Future
function c99199017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99199017.target)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c99199017.immfilter)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	c:RegisterEffect(e3)
	--Pos Change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c99199017.postg)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
end
function c99199017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c99199017.descon)
	e1:SetOperation(c99199017.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	c:RegisterEffect(e1)
end
function c99199017.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c99199017.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c99199017.immfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199017.postg(e,c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
