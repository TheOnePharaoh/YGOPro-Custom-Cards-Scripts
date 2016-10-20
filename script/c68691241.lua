--Sadist
function c68691241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c68691241.cost)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c68691241.target)
	e2:SetValue(c68691241.val)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c68691241.target)
	e3:SetValue(c68691241.val)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(68691241,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c68691241.opcost)
	e4:SetTarget(c68691241.optg1)
	e4:SetOperation(c68691241.opop1)
	c:RegisterEffect(e4)
	--to deck top
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(68691241,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(c68691241.opcost)
	e5:SetTarget(c68691241.optg2)
	e5:SetOperation(c68691241.opop2)
	c:RegisterEffect(e5)
end
function c68691241.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c68691241.target(e,c)
	return c:IsSetCard(0x0dac402) or c:IsSetCard(0x0dac403)
end
function c68691241.val(e,c)
	return c:GetLevel()*100
end
function c68691241.opcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x0dac406) and c:IsAbleToGraveAsCost() or c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x0dac406) and c:IsDiscardable()
end
function c68691241.opcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c68691241.opcfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c68691241.opcfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c68691241.chfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsAbleToGrave()
end
function c68691241.chfilter2(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405)
end
function c68691241.optg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c68691241.chfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c68691241.optg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c68691241.chfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c68691241.opop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c68691241.chfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c68691241.opop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(68691241,3))
	local g=Duel.SelectMatchingCard(tp,c68691241.chfilter2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
