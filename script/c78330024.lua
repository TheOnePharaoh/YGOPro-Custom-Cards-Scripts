--Cannibalize
function c78330024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c78330024.condition)
	e1:SetTarget(c78330024.target)
	e1:SetOperation(c78330024.activate)
	c:RegisterEffect(e1)
end
function c78330024.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xac9812)
end
function c78330024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78330024.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78330024.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c78330024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c78330024.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(c78330024.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*300)
end
function c78330024.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c78330024.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Recover(tp,ct*300,REASON_EFFECT)
end
