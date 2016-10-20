--ADE Skelegos
function c70649911.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649911,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c70649911.condition)
	e1:SetTarget(c70649911.target)
	e1:SetOperation(c70649911.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649911,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c70649911.atkcon)
	e2:SetOperation(c70649911.atkop)
	c:RegisterEffect(e2)
end
function c70649911.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_TUNER)
end
function c70649911.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70649911.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c70649911.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70649911.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c70649911.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c70649911.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649911.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c70649911.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c70649911.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
