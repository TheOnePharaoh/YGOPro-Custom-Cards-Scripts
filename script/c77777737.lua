--Necromantic Shaman
function c77777737.initial_effect(c)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c77777737.rlevel)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77777737.condition)
	e2:SetOperation(c77777737.operation)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c77777737.spcon)
	c:RegisterEffect(e3)
end

function c77777737.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x1c8) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c77777737.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c77777737.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if rc:IsSetCard(0x1c8)then
	while rc do
		if rc:GetFlagEffect(77777737)==0 then
			--immune
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(77777737,1))
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c77777737.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1,true)
			--gain atk
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCategory(CATEGORY_DEFCHANGE)
			e4:SetDescription(aux.Stringid(77777737,2))
			e4:SetCountLimit(1)
			e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e4:SetOperation(c77777737.defoperation)
			rc:RegisterEffect(e4,true)
			rc:RegisterFlagEffect(77777737,RESET_EVENT+0x1fe0000,0,1)
		end
		rc=eg:GetNext()
	end
	end
end

function c77777737.cfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER))
end
function c77777737.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777737.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c77777737.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end


function c77777737.defoperation(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
end