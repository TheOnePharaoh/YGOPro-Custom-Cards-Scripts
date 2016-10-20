--Outbreak
function c77628926.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c77628926.condition)
	e1:SetTarget(c77628926.target)
	e1:SetOperation(c77628926.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628926,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77628926.descon)
	e2:SetCost(c77628926.descost)
	e2:SetTarget(c77628926.destg)
	e2:SetOperation(c77628926.desop)
	c:RegisterEffect(e2)
end
function c77628926.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(77628924,tp)
end
function c77628926.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,LOCATION_HAND,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_HAND)
end
function c77628926.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	local dg1=g1:Filter(Card.IsType,nil,TYPE_MONSTER)
	local dg2=g2:Filter(Card.IsType,nil,TYPE_MONSTER)
	dg1:Merge(dg2)
	if dg1:GetCount()>0 then Duel.SendtoGrave(dg1,REASON_EFFECT+REASON_DISCARD) end
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
function c77628926.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628926.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628926.grafilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c77628926.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c77628926.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsDestructable()
end
function c77628926.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628926.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c77628926.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77628926.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77628926.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
