--Seafarer's Treasure Trove
function c66666699.initial_effect(c)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(66666699,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(1,66666699)
	e7:SetCondition(c66666699.condition)
	e7:SetTarget(c66666699.destg)
	e7:SetOperation(c66666699.desop)
	c:RegisterEffect(e7)
end
function c66666699.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66666699.cfilter,tp,LOCATION_MZONE,0,2,e:GetHandler())
end
function c66666699.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669)
end

function c66666699.filter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c66666699.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666699.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c66666699.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66666699.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c66666699.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Draw(tp,ct-1,REASON_EFFECT)
end
