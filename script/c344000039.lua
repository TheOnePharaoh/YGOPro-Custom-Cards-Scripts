function c344000039.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,344000014,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(344000039,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c344000039.condition)
	e3:SetTarget(c344000039.target)
	e3:SetOperation(c344000039.activate)
	c:RegisterEffect(e3)
end
function c344000039.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c344000039.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c344000039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c344000039.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c344000039.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c344000039.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c344000039.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
