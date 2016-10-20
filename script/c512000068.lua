--チューンナップ１２３
function c512000068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c512000068.target)
	e1:SetOperation(c512000068.activate)
	c:RegisterEffect(e1)
end
function c512000068.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:GetLevel()>0
end
function c512000068.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c512000068.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c512000068.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c512000068.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c512000068.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local d=Duel.TossDice(tp,1)
		local lv=0
		if d==1 or d==2 then
			lv=1
		elseif d==3 or d==4 then
			lv=2
		else
			lv=3
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
