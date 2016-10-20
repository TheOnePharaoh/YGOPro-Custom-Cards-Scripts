--The Idol Shine
function c59821033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821033,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,59821033+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59821033.condition1)
	e1:SetTarget(c59821033.target1)
	e1:SetOperation(c59821033.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821033,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,59821033+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c59821033.condition2)
	e2:SetTarget(c59821033.target2)
	e2:SetOperation(c59821033.operation2)
	c:RegisterEffect(e2)
	if not c59821033.global_check then
		c59821033.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c59821033.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c59821033.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,59821033,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,59821033,RESET_PHASE+PHASE_END,0,1) end
end
function c59821033.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821033.condition1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function c59821033.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821033.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c59821033.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(c59821033.atkfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local d=Duel.TossDice(tp,1)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(d*200)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end
function c59821033.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c59821033.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
end
function c59821033.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,59821033)~=0
end
function c59821033.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c59821033.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821033.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,3)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,3):Filter(c59821033.spfilter,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821033,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ShuffleDeck(tp)
end
