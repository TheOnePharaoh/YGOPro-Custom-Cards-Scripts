--Vocaloid Banshee
function c11251888.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--special summon1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11251888,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11251888)
	e2:SetCondition(c11251888.condition1)
	e2:SetTarget(c11251888.target1)
	e2:SetOperation(c11251888.operation1)
	c:RegisterEffect(e2)
	--special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11251888,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11251888)
	e3:SetCondition(c11251888.condition2)
	e3:SetTarget(c11251888.target2)
	e3:SetOperation(c11251888.operation2)
	c:RegisterEffect(e3)
	--spsummon3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11251888,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,11251888)
	e4:SetCondition(c11251888.condition3)
	e4:SetTarget(c11251888.target3)
	e4:SetOperation(c11251888.operation3)
	c:RegisterEffect(e4)
	if not c11251888.global_check then
		c11251888.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,11251888))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c11251888.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402)
end
function c11251888.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11251888.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c11251888.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11251888.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11251888.cfilter1,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c11251888.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac403)
end
function c11251888.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11251888.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c11251888.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11251888.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11251888.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11251888.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x0dac403)
end
function c11251888.cfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404)
end
function c11251888.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11251888.cfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c11251888.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1050)
end
function c11251888.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.Damage(tp,1050,REASON_EFFECT)
	end
end
