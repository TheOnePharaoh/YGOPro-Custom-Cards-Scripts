--Corrupted Vocaloid Ueki Type - 00
function c76973413.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76973413.spcon)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c76973413.synlimit)
	c:RegisterEffect(e2)
	--be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c76973413.exsumcon)
	e3:SetOperation(c76973413.exsumop)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0x0dac405)
	c:RegisterEffect(e4)
end
function c76973413.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TUNER) and c:GetCode()~=4
end
function c76973413.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c76973413.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c76973413.vfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TUNER) 
end
function c76973413.valcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c76973413.vfilter,c:GetControler(),LOCATION_MZONE,0,2,c)
end
function c76973413.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 or code==76973411 or code==76973412 or code==76973415 or code==76973416 or code==76973418 or code==76973419 or code==76973420 or code==76973421 then
	return else return not c:IsSetCard(0x301) end
end
function c76973413.exsumcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c76973413.exsumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76973413,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end