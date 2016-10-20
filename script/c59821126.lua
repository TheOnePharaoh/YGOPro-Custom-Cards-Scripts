--The Story of Unwavering Truth
function c59821126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c59821126.cost)
	e1:SetTarget(c59821126.target)
	e1:SetOperation(c59821126.activate)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821126,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,59821126)
	e2:SetCost(c59821126.xyzcost)
	e2:SetTarget(c59821126.xyztg)
	e2:SetOperation(c59821126.xyzop)
	c:RegisterEffect(e2)
end
function c59821126.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsDestructable()
end
function c59821126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821126.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c59821126.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c59821126.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c59821126.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c59821126.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c59821126.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c59821126.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821126.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c59821126.cofilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()
end
function c59821126.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821126.cofilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c59821126.cofilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c59821126.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa1a2) and c:GetOverlayCount()<2
end
function c59821126.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c59821126.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821126.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c59821126.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c59821126.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
