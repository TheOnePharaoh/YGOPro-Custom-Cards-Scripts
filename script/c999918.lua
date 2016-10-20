--Red Dragon Imposter
function c999918.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999918,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c999918.copytg)
	e1:SetOperation(c999918.copyop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c999918.condtion)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
end
function c999918.filter(c)
	return (c:IsSetCard(0x1045)) and c:IsType(TYPE_MONSTER)
		and not c:IsHasEffect(EFFECT_FORBIDDEN) and c:IsAbleToRemove()
end
function c999918.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999918.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999918.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c999918.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c999918.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then	return end
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end
function c999918.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler()
end
