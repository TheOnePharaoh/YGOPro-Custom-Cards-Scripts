--Dreadnought Mark - 005 Hector
function c22769905.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769905,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22769905)
	e1:SetCondition(c22769905.spcon)
	e1:SetTarget(c22769905.sptg)
	e1:SetOperation(c22769905.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c22769905.spfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND) and c:GetLevel()==10
end
function c22769905.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22769905.spfilter,1,nil,tp)
end
function c22769905.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769905.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local atk=c:GetBaseAttack()
		local def=c:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
