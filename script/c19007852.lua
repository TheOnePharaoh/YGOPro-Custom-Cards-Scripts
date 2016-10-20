--Mechquipped's Final Battle
function c19007852.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetTarget(c19007852.target)
	e1:SetOperation(c19007852.operation)
	c:RegisterEffect(e1)
end
function c19007852.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	end
end
function c19007852.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
