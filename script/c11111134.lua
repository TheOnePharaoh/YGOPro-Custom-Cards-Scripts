--Final Offering to the Light Goddess
function c11111134.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111134)
	e1:SetTarget(c11111134.target)
	e1:SetOperation(c11111134.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111134,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11111134.negcon)
	e2:SetCost(c11111134.negcost)
	e2:SetTarget(c11111134.negtg)
	e2:SetOperation(c11111134.negop)
	c:RegisterEffect(e2)
end
function c11111134.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x0dac401) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c11111134.matfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c11111134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c11111134.matfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(c11111134.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c11111134.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c11111134.matfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11111134.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11111134.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c11111134.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11111134.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111134.negop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c11111134.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c11111134.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
