--Passing Down the Generation
function c70649942.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c70649942.condition)
	e1:SetTarget(c70649942.target)
	e1:SetOperation(c70649942.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,70649942)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c70649942.sumcost)
	e2:SetTarget(c70649942.sumtg)
	e2:SetOperation(c70649942.sumop)
	c:RegisterEffect(e2)
end
function c70649942.confilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xd0a214)
end
function c70649942.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c70649942.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c70649942.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a214) and not c:IsType(TYPE_SYNCHRO) and c:IsDestructable()
end
function c70649942.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c70649942.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c70649942.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c70649942.desfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c70649942.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c70649942.tmpfilter1(c,e,tp)
	return c:IsSetCard(0xd0a214) and c:IsType(TYPE_SYNCHRO) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),cc,0x21,c:GetAttack(),c:GetDefence(),c:GetLevel(),c:GetRace(),c:GetAttribute(),POS_FACEUP_ATTACK,tp)
		and Duel.IsExistingMatchingCard(c70649942.tmpfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c70649942.tmpfilter2(c,e,tp,cd)
	return c:IsSetCard(0xd0a214) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(cd)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),cc,0x21,c:GetAttack(),c:GetDefence(),c:GetLevel(),c:GetRace(),c:GetAttribute(),POS_FACEUP_ATTACK,1-tp)
end
function c70649942.filter1(c,e,tp)
	return c:IsSetCard(0xd0a214) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.IsExistingMatchingCard(c70649942.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c70649942.filter2(c,e,tp,cd)
	return c:IsSetCard(0xd0a214) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(cd)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,1-tp)
end
function c70649942.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c70649942.tmpfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c70649942.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(c70649942.tmpfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 and sg:GetCount()>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c70649942.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(70649942,0))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(70649942,1))
		local g2=Duel.SelectMatchingCard(tp,c70649942.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,true,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_MUST_ATTACK)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_EP)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,0)
		e5:SetCondition(c70649942.becon)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e5)
		local e6=e5:Clone()
		tc2:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
	end
end
function c70649942.becon(e)
	return e:GetHandler():IsAttackable()
end