--スター・フォース
function c512000062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c512000062.cost)
	e1:SetTarget(c512000062.target)
	e1:SetOperation(c512000062.operation)
	c:RegisterEffect(e1)
end
function c512000062.cfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c)
end
function c512000062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000062.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,e:GetHandler():GetControler(),HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c512000062.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel()*200)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c512000062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetParam(e:GetLabel())
	e:SetLabel(0)
end
function c512000062.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
