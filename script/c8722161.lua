--Kryos Triple Attack
function c8722161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c8722161.condition)
	e1:SetTarget(c8722161.target)
	e1:SetOperation(c8722161.activate)
	c:RegisterEffect(e1)
end
function c8722161.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c8722161.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8722161.cfilter,tp,LOCATION_MZONE,0,1,nil,8722152)
		and Duel.IsExistingMatchingCard(c8722161.cfilter,tp,LOCATION_MZONE,0,1,nil,8722153)
		and Duel.IsExistingMatchingCard(c8722161.cfilter,tp,LOCATION_MZONE,0,1,nil,8722154)
end
function c8722161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c8722161.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
