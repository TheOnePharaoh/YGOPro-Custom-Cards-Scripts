--Utopia Rescue
function c112000008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c112000008.condition)
	e1:SetTarget(c112000008.target)
	e1:SetOperation(c112000008.activate)
	c:RegisterEffect(e1)
end
function c112000008.filter(c,e,tp)
	return c:GetCode()==84013237 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112000008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetAttacker():IsControler(1-tp)
end
function c112000008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112000008.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112000008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(58120309,0)) then 
			local g=Duel.GetFirstMatchingCard(c112000008.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
		end
	end
end