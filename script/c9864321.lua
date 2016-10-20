--Rank-Up Trap The Streaming Heart - Sign of Brutality
function c9864321.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9864321+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9864321.condition)
	e1:SetCost(c9864321.cost)
	e1:SetTarget(c9864321.target)
	e1:SetOperation(c9864321.activate)
	c:RegisterEffect(e1)
end
function c9864321.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	Duel.RegisterEffect(e3,tp)
end
function c9864321.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c9864321.filter1(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9864321.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank()+1,c.xyz_number)
end
function c9864321.filter2(c,e,tp,rank)
	return c:GetRank()==rank and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
			and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9864321.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9864321.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c9864321.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9864321.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9864321.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9864321.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank()+1,tc.xyz_number)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
