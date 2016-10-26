--Last Raid
function c90000064.initial_effect(c)
	--Remove/Damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c90000064.condition)
	e1:SetTarget(c90000064.target)
	e1:SetOperation(c90000064.operation)
	c:RegisterEffect(e1)
end
function c90000064.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1c)
end
function c90000064.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90000064.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)<=1000
end
function c90000064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c90000064.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(tp,ct*300,REASON_EFFECT)
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end