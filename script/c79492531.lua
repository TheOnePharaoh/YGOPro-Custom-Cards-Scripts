--Last Order - Genocide
function c79492531.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c79492531.condition)
	e1:SetTarget(c79492531.target)
	e1:SetOperation(c79492531.activate)
	c:RegisterEffect(e1)
end
function c79492531.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO)
end
function c79492531.filter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c79492531.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79492531.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c79492531.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79492531.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79492531.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
