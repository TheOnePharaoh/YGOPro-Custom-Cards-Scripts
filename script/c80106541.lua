--Sacred Seal of the Panticles
function c80106541.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c80106541.desrepcon)
	e2:SetTarget(c80106541.splimit)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c80106541.sdcon)
	c:RegisterEffect(e3)
	--self destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c80106541.sdcon)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1)
	e5:SetCondition(c80106541.negcon)
	e5:SetCost(c80106541.negcost)
	e5:SetTarget(c80106541.negtg)
	e5:SetOperation(c80106541.negop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80106541,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c80106541.spcon)
	e6:SetCost(c80106541.spcost)
	e6:SetTarget(c80106541.sptg)
	e6:SetOperation(c80106541.spop)
	c:RegisterEffect(e6)
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80106541,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c80106541.rmcost)
	e7:SetTarget(c80106541.rmtg)
	e7:SetOperation(c80106541.rmop)
	c:RegisterEffect(e7)
end
function c80106541.chilfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c80106541.desrepcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and not Duel.IsExistingMatchingCard(c80106541.chilfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c80106541.chilfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c80106541.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c80106541.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0xca00)
end
function c80106541.sdcon(e)
	return Duel.IsExistingMatchingCard(c80106541.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80106541.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)	and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c80106541.cfilter(c)
	return c:IsSetCard(0xca00) and c:IsDiscardable()
end
function c80106541.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80106541.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80106541.cfilter,1,1,REASON_COST+REASON_DISCARD+REASON_EFFECT)
end
function c80106541.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c80106541.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c80106541.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106541.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c80106541.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106541,0,0xca00,7,2300,1000,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80106541.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80106541,0,0xca00,7,2300,1000,RACE_MACHINE,ATTRIBUTE_DARK) then
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
function c80106541.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c80106541.tgfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToRemove()
end
function c80106541.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80106541.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80106541.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80106541.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c80106541.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
