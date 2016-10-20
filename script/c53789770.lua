--Hi, The Searing Taoist Dragon
function c53789770.initial_effect(c)
	--fus limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c53789770.interactlimit)
	c:RegisterEffect(e1)
	--sync limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(c53789770.interactlimit)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c53789770.interactlimit)
	c:RegisterEffect(e3)
	--end battle phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53789770,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,53789770)
	e4:SetCondition(c53789770.condition)
	e4:SetTarget(c53789770.target)
	e4:SetOperation(c53789770.operation)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e5:SetCondition(c53789770.sccon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c53789770.interactlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c53789770.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c53789770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c53789770.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1)
	end
end
function c53789770.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end