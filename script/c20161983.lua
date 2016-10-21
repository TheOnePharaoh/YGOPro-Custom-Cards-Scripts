--Zealot Lizardfolk - Gator Beast Master
function c20161983.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),6,2,c20161983.ovfilter,aux.Stringid(20161983,0),2,c20161983.xyzop)
	c:EnableReviveLimit()
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20161983,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c20161983.tdcost)
	e2:SetTarget(c20161983.tdtg)
	e2:SetOperation(c20161983.tdop)
	c:RegisterEffect(e2)
	--Unaffected by Opponent Card Effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c20161983.uncon)
	e3:SetValue(c20161983.unval)
	c:RegisterEffect(e3)
end
function c20161983.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_XYZ) and (rk==4 or rk==3)
end
function c20161983.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(20161983,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c20161983.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20161983.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return e:GetHandler():GetFlagEffect(20161983)==0
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c20161983.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c20161983.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and not c:IsCode(20161983)
end
function c20161983.uncon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c20161983.confilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c20161983.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
