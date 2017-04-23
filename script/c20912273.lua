--Sword Art Champion Icebrand Master Gwen
function c20912273.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912273,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e1:SetCountLimit(1)
	e1:SetCondition(c20912273.condition)
	e1:SetCost(c20912273.cost)
	e1:SetTarget(c20912273.target)
	e1:SetOperation(c20912273.operation)
	c:RegisterEffect(e1)
end
function c20912273.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0xd0a2)
end
function c20912273.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20912273.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2)
end
function c20912273.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c20912273.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912273.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20912273.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c20912273.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c20912273.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c20912273.cfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c20912273.filter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
