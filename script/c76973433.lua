--Vocaloid Kid Zatsune Miku
function c76973433.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c76973433.sumcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76973433,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,76973433)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c76973433.condition)
	e2:SetTarget(c76973433.target)
	e2:SetOperation(c76973433.operation)
	c:RegisterEffect(e2)
	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c76973433.syntg)
	e3:SetValue(1)
	e3:SetOperation(c76973433.synop)
	c:RegisterEffect(e3)
	--eff gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c76973433.indcon)
	e4:SetOperation(c76973433.indop)
	c:RegisterEffect(e4)
end
function c76973433.sumcon(e,c)
	if not c then return true end
	return false
end
function c76973433.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c76973433.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76973433.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c76973433.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c76973433.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
c76973433.tuner_filter=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)
function c76973433.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsRace(RACE_MACHINE) and (f==nil or f(c))
end
function c76973433.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c76973433.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c76973433.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c76973433.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c76973433.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c76973433.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76973433,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
