--Blackwing - Pinaka the Waxing Moon
function c512000109.initial_effect(c)
	--add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000766,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,512000109+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c512000109.con)
	e1:SetTarget(c512000109.target)
	e1:SetOperation(c512000109.operation)
	c:RegisterEffect(e1)
end
function c512000109.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c512000109.filter(c)
	return c:IsSetCard(0x33) and c:IsAbleToHand()
end
function c512000109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000109.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c512000109.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c512000109.filter,tp,LOCATION_GRAVE,0,1,999,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
