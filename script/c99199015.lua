--Inner Gear Overclock
function c99199015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99199015,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99199015)
	e1:SetCost(c99199015.cost)
	e1:SetTarget(c99199015.target1)
	e1:SetOperation(c99199015.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199015,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99199015)
	e2:SetCost(c99199015.cost)
	e2:SetTarget(c99199015.target2)
	e2:SetOperation(c99199015.activate2)
	c:RegisterEffect(e2)
end
function c99199015.costfilter(c)
	return c:IsSetCard(0xff15) and c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99199015.cost(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.CheckReleaseGroup(tp,c99199015.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c99199015.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c99199015.filter1(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c99199015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199015.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c99199015.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c99199015.activate1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c99199015.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c99199015.filter2(c)
	return c:IsDestructable()
end
function c99199015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199015.filter2,tp,0,LOCATION_SZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c99199015.filter2,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c99199015.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c99199015.filter2,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
