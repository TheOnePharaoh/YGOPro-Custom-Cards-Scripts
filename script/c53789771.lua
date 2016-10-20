--Mizu, The Ocean Taoist Dragon
function c53789771.initial_effect(c)
	--fus limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c53789771.interactlimit)
	c:RegisterEffect(e1)
	--sync limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(c53789771.interactlimit)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c53789771.interactlimit)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53789771,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,53789771)
	e4:SetCondition(c53789771.condition)
	e4:SetTarget(c53789771.target)
	e4:SetOperation(c53789771.operation)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(53789771,1))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c53789771.sumcon)
	e5:SetTarget(c53789771.sumtg)
	e5:SetOperation(c53789771.sumop)
	c:RegisterEffect(e5)
end
function c53789771.interactlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WYRM)
end
function c53789771.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function c53789771.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53789771.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c53789771.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53789771.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c53789771.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		c:RegisterFlagEffect(53789771,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1,true)
	end
end
function c53789771.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53789771)~=0
end
function c53789771.sumfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c53789771.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53789771.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c53789771.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c53789771.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end