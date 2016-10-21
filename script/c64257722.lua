--Vocaloid Trap Catbox
function c64257722.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c64257722.condition)
	e1:SetTarget(c64257722.target)
	e1:SetOperation(c64257722.activate)
	c:RegisterEffect(e1)
end
function c64257722.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c64257722.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64257722.cfilter,1,nil,tp)
end
function c64257722.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(2) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64257722.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c64257722.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and Duel.IsExistingTarget(c64257722.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c64257722.filter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c64257722.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2,true)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
