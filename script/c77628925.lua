--Borrowed Time
function c77628925.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c77628925.condition1)
	e1:SetTarget(c77628925.target1)
	e1:SetOperation(c77628925.activate1)
	c:RegisterEffect(e1)
end
function c77628925.check(tp)
	local ret=false
	for i=0,4 do
		local c=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if c and c:IsFaceup() then
			if c:IsSetCard(0xba003) then ret=true else return false end
		end
	end
	return ret
end
function c77628925.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and c77628925.check(tp)
end
function c77628925.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c77628925.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg:GetFirst())
	local ec=eg:GetFirst()
	Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetOperation(c77628925.retop)
	ec:RegisterEffect(e1)
end
function c77628925.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
