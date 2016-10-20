--Joker - Song of Bad Omen and Cruel Joke
function c98100025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,98100025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98100025.condition)
	e1:SetTarget(c98100025.target)
	e1:SetOperation(c98100025.activate)
	c:RegisterEffect(e1)
end
function c98100025.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return not tc:IsRace(RACE_MACHINE) and tc:IsControler(1-tp) and tc:GetAttack()>=Duel.GetLP(tp) and Duel.GetAttackTarget()==nil
end
function c98100025.filter(c,e,tp)
	return c:IsSetCard(0x0dac404) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98100025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98100025.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98100025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98100025.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local a=Duel.GetAttacker()
		if a:IsRelateToBattle() and a:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(a:GetAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
			Duel.CalculateDamage(a,tc)
		end
	end
end
