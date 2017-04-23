--The Future Gear Arch Cleric Hellen
function c99199035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c99199035.discon)
	e1:SetTarget(c99199035.distg)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199035,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_XMDETACH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c99199035.thcost)
	e2:SetTarget(c99199035.thtg)
	e2:SetOperation(c99199035.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c99199035.destg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c99199035.discon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c99199035.distg(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(99199035)
end
function c99199035.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99199035.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99199035.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c99199035.rfilter(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99199035.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and dc~=e:GetHandler() and dc:IsFaceup() and dc:IsLocation(LOCATION_MZONE) and dc:IsControler(tp)
		and dc:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c99199035.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(99199035,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c99199035.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		return true
	else return false end
end
