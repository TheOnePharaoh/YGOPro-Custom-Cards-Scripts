--パワー・バトン
function c512000055.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c512000055.cost)
	e1:SetTarget(c512000055.target)
	e1:SetOperation(c512000055.operation)
	c:RegisterEffect(e1)
end
function c512000055.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c512000055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000055.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c512000055.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetTextAttack())
end
function c512000055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetParam(e:GetLabel())
	e:SetLabel(0)
end
function c512000055.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if atk<0 then atk=0 end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCode(EFFECT_DRAW_COUNT)
		e2:SetValue(0)
		e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
	end
end
