--Error - Song of Confusion
function c76973428.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76973428+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76973428.cost)
	e1:SetTarget(c76973428.target)
	e1:SetOperation(c76973428.activate)
	c:RegisterEffect(e1)
end
function c76973428.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c76973428.filter(c,e,tp)
	return c:IsCode(76973411) or c:IsCode(76973412) or c:IsCode(76973415) or c:IsCode(76973416) or c:IsCode(76973418) or c:IsCode(76973419) or c:IsCode(76973420) or c:IsCode(76973421)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false)
end
function c76973428.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c76973428.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76973428.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76973428.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(c76973428.desop)
		tc:RegisterEffect(e2,true)
		tc:CompleteProcedure()
	end
end
function c76973428.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
