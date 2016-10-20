--The Only One
function c46774208.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,46774208+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c46774208.spcon)
	e1:SetTarget(c46774208.sptg)
	e1:SetOperation(c46774208.spop)
	c:RegisterEffect(e1)
end
function c46774208.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c46774208.filter(c,e,tp)
	return c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=6
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c46774208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and at:IsOnField() and at:GetAttack()>=Duel.GetLP(tp)
		and not at:IsRace(RACE_MACHINE) end
end
function c46774208.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c46774208.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(46774208,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
