--Wish for Fortunation
function c59821035.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821035,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c59821035.condition1)
	e1:SetCost(c59821035.cost1)
	e1:SetTarget(c59821035.target1)
	e1:SetOperation(c59821035.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821035,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c59821035.condition2)
	e2:SetTarget(c59821035.target2)
	e2:SetOperation(c59821035.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function c59821035.condition1(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function c59821035.costfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost()
end
function c59821035.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821035.costfilter,tp,LOCATION_EXTRA,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c59821035.costfilter,tp,LOCATION_EXTRA,0,4,4,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c59821035.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821035.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then
			return Duel.IsExistingMatchingCard(c59821035.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		else
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c59821035.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		end
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c59821035.ctfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE+LOCATION_DECK)
end
function c59821035.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.Destroy(g,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c59821035.ctfilter,nil,1-tp)
	if ft>ct then ft=ct end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=Duel.SelectMatchingCard(tp,c59821035.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c59821035.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() 
end
function c59821035.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821035.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821035.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c59821035.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821035.filter2,tp,LOCATION_MZONE,0,nil)
	local atk=g:GetCount()*200
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
