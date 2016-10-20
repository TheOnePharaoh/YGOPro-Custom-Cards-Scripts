--Vocalist Sunday Naptime
function c18525841.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18525841.condition)
	e1:SetTarget(c18525841.target)
	e1:SetOperation(c18525841.activate)
	c:RegisterEffect(e1)
end
function c18525841.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c18525841.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c18525841.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18525841.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c18525841.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18525841.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c18525841.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c18525841.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c18525841.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END, 1)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
