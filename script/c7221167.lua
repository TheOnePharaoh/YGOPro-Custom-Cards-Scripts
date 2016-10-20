--Vocaloid Rin Kagamine - Daughter of Evil
function c7221167.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsCode,41045206))
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c7221167.indval)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--immune trap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c7221167.efilter)
	c:RegisterEffect(e3)
	--spsum success
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7221167,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--disable summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SUMMON_COUNT_LIMIT)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetValue(c7221167.sumval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_FLIP_SUMMON_COUNT_LIMIT)
	c:RegisterEffect(e7)
	if not c7221167.global_check then
		c7221167.global_check=true
		c7221167[0]=0
		c7221167[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c7221167.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge2:SetOperation(c7221167.checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetOperation(c7221167.checkop)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(c7221167.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c7221167.sumval(e,se,sp)
	return 2-c7221167[sp]
end
function c7221167.checkop(e,tp,eg,ep,ev,re,r,rp)
	local s1=false
	local s2=false
	local tc=eg:GetFirst()
	while tc do
		if tc:GetSummonPlayer()==0 then s1=true
		else s2=true end
		tc=eg:GetNext()
	end
	if s1 then c7221167[0]=c7221167[0]+1 end
	if s2 then c7221167[1]=c7221167[1]+1 end
end
function c7221167.clear(e,tp,eg,ep,ev,re,r,rp)
	c7221167[0]=0
	c7221167[1]=0
end
function c7221167.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c7221167.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end