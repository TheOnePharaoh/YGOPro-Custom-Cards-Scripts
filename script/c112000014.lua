--Corrupted Metal Dragon
function c112000014.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112000014,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c112000014.target)
	e1:SetOperation(c112000014.operation)
	c:RegisterEffect(e1)
end
function c112000014.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c112000014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112000014.sfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c112000014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c112000014.sfilter,tp,LOCATION_HAND,0,nil)
	local sg=g:Select(tp,1,1,nil):GetFirst()
	if sg and Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)~=0 and c:IsFaceup() then
		local ba=sg:GetBaseAttack()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
	end
end

