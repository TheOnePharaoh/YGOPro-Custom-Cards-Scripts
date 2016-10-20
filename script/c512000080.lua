--Millennium Thousand-Eyes Virus
function c512000080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c512000080.cost)
	e1:SetTarget(c512000080.target)
	e1:SetOperation(c512000080.activate)
	c:RegisterEffect(e1)
end
function c512000080.costfilter1(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackBelow(1000) 
		and Duel.CheckReleaseGroup(tp,c512000080.costfilter2,1,nil,tp)
end
function c512000080.costfilter2(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackAbove(2000) 
		and Duel.CheckReleaseGroup(tp,c512000080.costfilter3,1,c,tp,c)
end
function c512000080.costfilter3(c,tp,c1)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackAbove(2500) 
		and Duel.CheckReleaseGroup(tp,c512000080.costfilter4,1,c,c1)
end
function c512000080.costfilter4(c,card)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttackAbove(3000) and c~=card 
end
function c512000080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c512000080.costfilter1,1,nil,tp) end
	local g1=Duel.SelectReleaseGroup(tp,c512000080.costfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c512000080.costfilter2,1,1,nil,tp,g1:GetFirst())
	local g3=Duel.SelectReleaseGroup(tp,c512000080.costfilter3,1,1,g2:GetFirst(),tp)
	local g4=Duel.SelectReleaseGroup(tp,c512000080.costfilter4,1,1,g3:GetFirst(),g2:GetFirst())
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.Release(g1,REASON_COST)
end
function c512000080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,0x4f,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,0x4f,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c512000080.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,0x4f,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
