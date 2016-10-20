--Vocaloid Sinsy
function c86221226.initial_effect(c)
	c:SetUniqueOnField(1,0,86221226)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86221226,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,86221226)
	e1:SetCondition(c86221226.spcon)
	e1:SetTarget(c86221226.sptg)
	e1:SetOperation(c86221226.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86221226,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c86221226.condition)
	e2:SetTarget(c86221226.target)
	e2:SetOperation(c86221226.operation)
	c:RegisterEffect(e2)
	--cannot synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c86221226.synlimit1)
	c:RegisterEffect(e3)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
end
function c86221226.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSetCard(0x0dac402) and c:IsRace(RACE_MACHINE) and c:IsReason(REASON_DESTROY)
end
function c86221226.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c86221226.cfilter,1,nil,tp)
end
function c86221226.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c86221226.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),200,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c86221226.condition(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c86221226.atkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c86221226.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c86221226.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86221226.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectTarget(tp,c86221226.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c86221226.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c86221226.synlimit1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x0dac402)
end