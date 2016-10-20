--Light of Purification
function c59821073.initial_effect(c)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821073,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,59821073)
	e1:SetCondition(c59821073.condition1)
	e1:SetOperation(c59821073.activate1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821073,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,59821073)
	e2:SetCondition(c59821073.condition2)
	e2:SetTarget(c59821073.target)
	e2:SetOperation(c59821073.activate2)
	c:RegisterEffect(e2)
end
function c59821073.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return at and ((a:IsControler(tp) and a:IsSetCard(0xa1a2))
		or (at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0xa1a2)))
end
function c59821073.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	if not a:IsRelateToBattle() or a:IsFacedown() or not at:IsRelateToBattle() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(at:GetAttack())
	a:RegisterEffect(e1)
end
function c59821073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2)
end
function c59821073.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821073.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function c59821073.filter(c,e,tp)
	return c:IsSetCard(0xa1a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c59821073.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c59821073.locfilter(c,sp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(sp)
end
function c59821073.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local ct1=Duel.GetOperatedGroup():FilterCount(c59821073.locfilter,nil,tp)
	local ct2=Duel.GetOperatedGroup():FilterCount(c59821073.locfilter,nil,1-tp)
	if ct1>Duel.GetLocationCount(tp,LOCATION_MZONE) then ct1=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	if ct2>Duel.GetLocationCount(1-tp,LOCATION_MZONE) then ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE) end
	if ct1<=0 then return end
	local g=Duel.GetMatchingGroup(c59821073.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	ct1=ct1-1
	while ct1>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821073,2)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		sg:Merge(g1)
		ct1=ct1-1
	end
	local sc=sg:GetFirst()
	while sc do
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
			sc:RegisterEffect(e1)
		end
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	if ct2>0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_DECK,1,nil,e,0,1-tp,false,false)
		and Duel.SelectYesNo(1-tp,aux.Stringid(59821073,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_DECK,1,ct2,nil,e,0,1-tp,false,false)
		if sg2:GetCount()>0 then
			Duel.SpecialSummon(sg2,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
