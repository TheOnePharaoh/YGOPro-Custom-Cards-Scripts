--Vocaloid Zatsune Miku
function c67152332.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c67152332.sumcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67152332,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,67152332)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67152332.condition)
	e2:SetTarget(c67152332.target)
	e2:SetOperation(c67152332.operation)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
	--synchro custom
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c67152332.syntg)
	e4:SetValue(1)
	e4:SetOperation(c67152332.synop)
	c:RegisterEffect(e4)
end
function c67152332.sumcon(e,c)
	if not c then return true end
	return false
end
function c67152332.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c67152332.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67152332.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67152332.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67152332.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
c67152332.tuner_filter=aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE)
function c67152332.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsRace(RACE_MACHINE) and (f==nil or f(c))
end
function c67152332.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c67152332.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c67152332.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c67152332.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
