--MSMM - Witch Devastation
function c99950180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99950180.condition)
	e1:SetTarget(c99950180.target)
	e1:SetOperation(c99950180.activate)
	c:RegisterEffect(e1)
end
function c99950180.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9995) and c:IsLevelAbove(1)
end
function c99950180.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99950180.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function c99950180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99950180.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c99950180.filter1,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,ct,nil)
	if g:GetCount()>0 then
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	end
end