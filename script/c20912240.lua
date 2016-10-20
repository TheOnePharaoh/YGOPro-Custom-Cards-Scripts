--klein
function c20912240.initial_effect(c)
	--lv gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912240,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c20912240.condition)
	e1:SetTarget(c20912240.target)
	e1:SetOperation(c20912240.operation)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c20912240.synlimit)
	c:RegisterEffect(e2)
end
function c20912240.condition(e)
	return e:GetHandler():GetEquipCount()>0
end
function c20912240.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2)
end
function c20912240.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20912240.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912240.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20912240.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(20912240,1),aux.Stringid(20912240,2))
	else op=Duel.SelectOption(tp,aux.Stringid(20912240,1),aux.Stringid(20912240,2)) end
	e:SetLabel(op)
end
function c20912240.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(3) end
		tc:RegisterEffect(e1)
	end
end
function c89258906.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WARRIOR)
end
