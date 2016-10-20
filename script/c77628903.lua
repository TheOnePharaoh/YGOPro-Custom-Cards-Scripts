--Venom Snare of the Black Art
function c77628903.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--end battle phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628903,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77628903.condition)
	e2:SetTarget(c77628903.target)
	e2:SetOperation(c77628903.operation)
	c:RegisterEffect(e2)
	--synchro custom
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTarget(c77628903.syntg)
	e3:SetValue(1)
	e3:SetOperation(c77628903.synop)
	c:RegisterEffect(e3)
end
function c77628903.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c77628903.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77628903.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
function c77628903.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c77628903.synfilter2(c,syncard,tuner,f)
	return c:IsSetCard(0xba003) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c77628903.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c77628903.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_ZOMBIE) then
		local exg=Duel.GetMatchingGroup(c77628903.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
function c77628903.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c77628903.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_ZOMBIE) then
		local exg=Duel.GetMatchingGroup(c77628903.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
