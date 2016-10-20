--The Third Panticle of Mars
function c80106542.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c80106542.discon)
	e1:SetCost(c80106542.discost)
	e1:SetTarget(c80106542.distg)
	e1:SetOperation(c80106542.disop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c80106542.sdcon)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c80106542.handcon)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c80106542.aclimit)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80106542,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c80106542.spcon)
	e5:SetCost(c80106542.spcost)
	e5:SetTarget(c80106542.sptg)
	e5:SetOperation(c80106542.spop)
	c:RegisterEffect(e5)
end
function c80106542.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c80106542.disfilter(c)
	return c:IsSetCard(0xca00) and c:IsDiscardable()
end
function c80106542.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80106542.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80106542.cfilter,1,1,REASON_COST+REASON_DISCARD+REASON_EFFECT)
end
function c80106542.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80106542.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c80106542.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0xca00)
end
function c80106542.sdcon(e)
	return Duel.IsExistingMatchingCard(c80106542.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106542.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca00)
end
function c80106542.handcon(e)
	return Duel.IsExistingMatchingCard(c80106542.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106542.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c80106542.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106542.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c80106542.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106542,0,0xca00,4,1600,1400,RACE_INSECT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80106542.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106542,0,0xca00,4,1600,1400,RACE_INSECT,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetReset(RESET_EVENT+0x47e0000)
		e7:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e7,true)
	end
end