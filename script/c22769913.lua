--Dreadnought Mark - Z01 Elysium
function c22769913.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),10,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Cost Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LPCOST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c22769913.dscon)
	e3:SetValue(c22769913.costchange)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISCARD_COST_CHANGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22769913.dscon)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--search monster
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22769913,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22769913)
	e5:SetCost(c22769913.cost)
	e5:SetTarget(c22769913.target1)
	e5:SetOperation(c22769913.operation1)
	c:RegisterEffect(e5)
	--search trap
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22769913,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,22769913)
	e6:SetCost(c22769913.cost)
	e6:SetTarget(c22769913.target2)
	e6:SetOperation(c22769913.operation2)
	c:RegisterEffect(e6)
end
function c22769913.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22769913.costchange(e,re,rp,val)
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_COUNTER) then
		return 0
	else
		return val
	end
end
function c22769913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22769913.filter1(c)
	return c:IsLevelAbove(10) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c22769913.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769913.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22769913.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22769913.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22769913.filter2(c)
	return c:IsSetCard(0xaa12) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c22769913.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769913.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22769913.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22769913.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end