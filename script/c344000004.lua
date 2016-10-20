--Garbage Djinn
function c344000004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),5,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(344000004,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c344000004.target)
	e1:SetOperation(c344000004.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(344000004,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c344000004.damcost)
	e2:SetTarget(c344000004.damtg)
	e2:SetOperation(c344000004.damop)
	c:RegisterEffect(e2)
end
function c344000004.filter(c)
	return (c:IsSetCard(0x444) or c:IsCode(44682448) or c:IsCode(18698739)) and c:IsAbleToHand()
end
function c344000004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c344000004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c344000004.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c344000004.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c344000004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,2,REASON_EFFECT)
	end
end
function c344000004.filter2(c)
	return c:IsFaceup() and (c:IsSetCard(0x444) or c:IsCode(44682448) or c:IsCode(18698739))
end
function c344000004.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c344000004.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c344000004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c344000004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c344000004.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c344000004.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
