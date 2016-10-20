--Sword Art Champion Lilia
function c20912282.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912282,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c20912282.condition)
	e2:SetTarget(c20912282.target)
	e2:SetOperation(c20912282.operation)
	c:RegisterEffect(e2)
end
function c20912282.condition(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xd0a2)
end
function c20912282.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and not c:IsType(TYPE_XYZ)
end
function c20912282.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20912282.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912282.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20912282.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(20912282,1))
	else op=Duel.SelectOption(tp,aux.Stringid(20912282,1),aux.Stringid(20912282,2)) end
	e:SetLabel(op)
end
function c20912282.operation(e,tp,eg,ep,ev,re,r,rp)
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
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
