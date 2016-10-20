--Humanity
--lua script by SGJin
function c12310712.initial_effect(c)
	--Lvl + 1
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetTarget(c12310712.target)
	e1:SetOperation(c12310712.operation)
	c:RegisterEffect(e1)
end
function c12310712.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c12310712.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12310712.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310712.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local tc=Duel.SelectTarget(tp,c12310712.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tc:GetControler(),tc:GetLevel()*100+100)
end
function c12310712.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		Duel.Recover(tc:GetControler(),tc:GetLevel()*100,REASON_EFFECT)
	end
end

