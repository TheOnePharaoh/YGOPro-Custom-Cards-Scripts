--ANTI-MATTER Flux
function c1143243.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c1143243.cost)
	e1:SetTarget(c1143243.target)
	e1:SetOperation(c1143243.activate)
	c:RegisterEffect(e1)
	if not c1143243.global_check then
		c1143243.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143243))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143243.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDestructable()
end
function c1143243.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143243.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1143243.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c1143243.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1143243.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c1143243.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c1143243.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1143243.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143243.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
