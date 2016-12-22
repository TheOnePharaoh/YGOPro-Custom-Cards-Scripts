function c56540039.initial_effect(c)
aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(37926346,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON+EVENT_SUMMON)
	e1:SetCountLimit(1)
	e1:SetCondition(c56540039.condition)
	e1:SetTarget(c56540039.target1)
	e1:SetOperation(c56540039.operation1)
	c:RegisterEffect(e1)
local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_PIERCE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetTarget(c56540039.target)
	c:RegisterEffect(e11)
end
function c56540039.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c56540039.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c56540039.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg:GetFirst())
	Duel.Destroy(eg,REASON_EFFECT)
end
function c56540039.target(e,c)
	return c:IsType(TYPE_MONSTER)
end