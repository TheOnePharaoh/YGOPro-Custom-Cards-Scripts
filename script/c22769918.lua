--Battle Confrontation
function c22769918.initial_effect(c)
	c:SetUniqueOnField(1,0,22769918)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c22769918.drop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22769918.chaincon)
	e3:SetOperation(c22769918.chainop)
	c:RegisterEffect(e3)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_EP)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c22769918.becon)
	c:RegisterEffect(e5)
	--material
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22769918,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCost(c22769918.matcost)
	e6:SetTarget(c22769918.mattg)
	e6:SetOperation(c22769918.matop)
	c:RegisterEffect(e6)
end
function c22769918.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_COUNTER) then return end
	Duel.Hint(HINT_CARD,0,22769918)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22769918.conditfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c22769918.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22769918.conditfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c22769918.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0xaa12) and re:IsActiveType(TYPE_COUNTER) then
		Duel.SetChainLimit(c22769918.chainlm)
	end
end
function c22769918.chainlm(e,rp,tp)
	return tp==rp
end
function c22769918.becon(e)
	return Duel.IsExistingMatchingCard(Card.IsAttackable,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22769918.costfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGraveAsCost()
end
function c22769918.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22769918.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22769918.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22769918.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c22769918.matfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function c22769918.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22769918.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22769918.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c22769918.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22769918.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22769918.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c22769918.matfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end