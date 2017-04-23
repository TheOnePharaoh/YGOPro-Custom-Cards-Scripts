--Vocalist Ultimate Alternation Infector Miku
function c63118411.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,4)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(63118411,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e2:SetCost(c63118411.cost)
	e2:SetTarget(c63118411.target)
	e2:SetOperation(c63118411.operation)
	c:RegisterEffect(e2)
end
function c63118411.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c63118411.filter(c)
	return c:IsFaceup() and c:IsAttribute(0x5f)
end
function c63118411.tfilter(c)
	return not c:IsAbleToRemove()
end
function c63118411.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c63118411.filter,tp,0,LOCATION_MZONE,nil)
		return g:GetCount()>0 and not g:IsExists(c63118411.tfilter,1,nil)
	end
	local g=Duel.GetMatchingGroup(c63118411.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c63118411.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c63118411.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
