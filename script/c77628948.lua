--Kael, Catastrophic Dragon of the Black Art
function c77628948.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c77628948.ffilter,aux.FilterBoolFunction(Card.IsCode,77628914),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628948.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77628948.spcon)
	e2:SetOperation(c77628948.spop)
	c:RegisterEffect(e2)
	--summon cannot be negated
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77628948,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c77628948.negop)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77628948.immcon)
	e5:SetValue(c77628948.efilter)
	c:RegisterEffect(e5)
end
function c77628948.ffilter(c)
	return c:IsCode(77628917)
end
function c77628948.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628948.spfilter1(c,tp,fc)
	return c:IsCode(77628917) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c77628948.spfilter2,1,c,fc)
end
function c77628948.spfilter2(c,fc)
	return c:IsCode(77628914) and c:IsCanBeFusionMaterial(fc)
end
function c77628948.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c77628948.spfilter1,1,nil,tp,c)
end
function c77628948.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c77628948.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c77628948.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c77628948.negfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_ZOMBIE) and not c:IsDisabled()
end
function c77628948.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77628948.negfilter,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c77628948.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77628948.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function c77628948.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628948.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c77628948.grafilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=5
end
function c77628948.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end
