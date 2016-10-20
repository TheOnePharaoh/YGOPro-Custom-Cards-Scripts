--Symbol Fragment:Rule
function c77790019.initial_effect(c)
	--reverse
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77790019.con)
	e1:SetTarget(c77790019.target)
	e1:SetOperation(c77790019.operation)
	c:RegisterEffect(e1)
end
function c77790019.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77790019.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c77790019.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x100f)
end
function c77790019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c77790019.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c77790019.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c77790019.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
